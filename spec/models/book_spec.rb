require 'rails_helper'

RSpec.describe Book, type: :model do
    context "validation tests" do
        
        # let(:category) { build :category }
        let(:book)  { build :book }

        it "book title should be presence" do
            expect(book.title).to eq "Ruby" 
            book.title = ''
            expect(book.save).to eq(false) 
            book.title = nil
            expect(book.save).to eq(false) 
        end

        it "book sort should be a number" do
            book.sort = nil
            expect(book.save).to eq(false)
        end
        
    end

    context "scope tests" do
        
        # let(:category) { build :category }
        let(:author1) { build :author, id: 1 }
        let(:author2) { build :author, id: 2, name: 'IBM' }
        let(:book)  { build :book, authors: [author1, author2] }

        before(:each) do
            book.save
        end

        it "it should return book by category" do
            expect(Book.find_by_category(1).size).to eq(1)
        end

        it "it should return book by keyword" do
            expect(Book.find_by_keyword('R').size).to eq(1)
        end

        it "it should return book by author" do
            expect(book.authors.size).to eq(2)
            expect(Book.find_by_author(1).size).to eq(1)
        end

        it "it should return book by publish date" do
            expect(Book.find_by_publish_date('08/02/2021').size).to eq(1)
        end
    end
    
    
end