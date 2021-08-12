require 'rails_helper'

RSpec.describe "Books", type: :request do

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

    let!(:author) { FactoryBot.create :author }
    let!(:category) { FactoryBot.create :category, title: 'Programming Language' }
    context "POST #create" do
        it "should redirect to index" do
            post books_path, params: { book: FactoryBot.attributes_for(:book, publish_date: '08/02/2021', author_ids: [author.id], category_id: category.id) }
            expect(response).to redirect_to books_path
        end

        it "should create new book" do
            post books_path, params: { book: FactoryBot.attributes_for(:book, publish_date: '08/02/2021', author_ids: [author.id], category_id: category.id) }
            expect(Book.count).to eq(1)
        end
    end

    context "PUT #put" do
        it "should redirect to index and update " do
            book = FactoryBot.create :book
            book.save
            put book_path(book), params: { book: FactoryBot.attributes_for(:book, title: 'Test', publish_date: '08/02/2021', author_ids: [author.id], category_id: category.id) }
            expect(response).to redirect_to books_path
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
    
    
end
