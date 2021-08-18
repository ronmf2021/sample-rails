require 'rails_helper'

RSpec.describe "Books", type: :request do

    include ActionDispatch::TestProcess::FixtureFile

    context "GET #index" do
        let!(:books) { FactoryBot.create_list :book, 5 } 

        it "should success" do
            get books_path
            expect(response).to be_successful
        end

        it "should return books" do
            get books_path
            expect(assigns(:books)).to eq(books)
        end

        it "should render template" do
            get books_path
            expect(response).to render_template(:index)
        end
    end

    context "GET #show" do
        let!(:book) { FactoryBot.create :book } 
        it "should return a book" do
            get book_path(book)
            expect(assigns(:book)).to eq(book)
        end

        it "should render show template" do
            get book_path(book)
            expect(response).to render_template(:show)
        end
    end

    
    context "POST #create" do
        let!(:author) { FactoryBot.create :author }
        let!(:category) { FactoryBot.create :category, title: 'Programming Language' }
        
        it "should redirect to index" do
            post books_path, params: { book: FactoryBot.attributes_for(:book, publish_date: '08/02/2021', author_ids: [author.id], category_id: category.id) }
            expect(response).to redirect_to book_path(assigns[:book])
        end

        it "should create new book" do
            post books_path, params: { book: FactoryBot.attributes_for(:book, publish_date: '08/02/2021', author_ids: [author.id], category_id: category.id) }
            expect(Book.count).to eq(1)
        end
    end

    context "PUT #put" do
        let!(:author) { FactoryBot.create :author }
        let!(:category) { FactoryBot.create :category, title: 'Programming Language' }

        it "should redirect to index and update " do
            book = FactoryBot.create :book
            book.save
            put book_path(book), params: { book: FactoryBot.attributes_for(:book, title: 'Test', publish_date: '08/02/2021', author_ids: [author.id], category_id: category.id) }
            expect(response).to redirect_to book_path(book)
            expect(Book.find(book.id).title).to eq('Test')
        end     
    end

    context "DELETE #delete" do
        it "should redirect to index" do
            book = FactoryBot.create :book
            book.save
            delete book_path(book)
            expect(response).to redirect_to books_path
            expect(Book.exists?(book.id)).to be false
            expect { book.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
    end

    context "GET #import" do
        it "should render template" do
            get import_books_path
            expect(response).to render_template(:import)
        end
    end

    context "POST #upload" do
        let!(:csv_file) { fixture_file_upload("book-sample-test-success.csv", "text/csv") }
        it "should redirect to index" do
           post upload_books_path, params: { csv_file: csv_file } 
           expect(response).to redirect_to books_path
        end 
    end

    context "POST #export" do
        it "should return csv file" do
            post export_books_path(format: "csv")
            expect(response.header['Content-Type']).to eq("text/csv")
        end
    end
    
end
