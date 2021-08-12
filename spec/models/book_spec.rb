require 'rails_helper'

RSpec.describe Book, type: :model do

    context "has association" do
        it "belongs to category" do
            is_expected.to belong_to(:category)
        end 

        it "have belongs to many" do
            is_expected.to have_and_belong_to_many(:authors)
        end

        it "have on attached image" do
            is_expected.to have_one_attached(:image)
        end
    end
    
    context "validation tests" do
        it "book title should be presence" do
            is_expected.to validate_presence_of(:title)
        end
    end

    context "scope tests" do
        
        let!(:author1) { FactoryBot.create :author }
        let!(:author2) { FactoryBot.create :author, name: 'Oracle' }
        let!(:category) { FactoryBot.create :category, title: 'Programming Language' }
        let!(:book)  { FactoryBot.create :book, authors: [author1, author2], title: 'Ruby', publish_date: DateTime.parse('2021-08-02'), category: category }

        it "it should return book by category" do
            expect(Book.find_by_category(category.id).first).to eq(book)
        end

        it "it should return book by keyword" do
            expect(Book.find_by_keyword('R').first).to eq(book)
        end

        it "it should return book by author" do
            expect(book.authors.size).to eq(2)
            expect(Book.find_by_author(author1.id).first).to eq(book)
        end

        it "it should return book by publish date" do
            expect(Book.find_by_publish_date('08/02/2021').first).to eq(book)
        end
    end
    
    
end