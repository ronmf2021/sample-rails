require 'rails_helper'

RSpec.feature "Books", type: :feature do
  before(:all) do
    create(:category, title: 'OS')
    create(:category, title: 'DB')
    create(:author, name: 'IBM')
  end
  
  scenario "create new book" do
    visit "/books/new"
      fill_in "Title",	with: "Mysql"
      fill_in "Sort",	with: "1" 
      select('DB', from: 'book_category_id')
      select('IBM', from: 'book_author_ids')
      fill_in "Publish date",	with: "08/11/2021"
      
      click_button "Apply"
      expect(page).to have_text("Book was successfully created.") 
  end

  scenario "update book" do
    book = FactoryBot.create :book
    book.save
    visit "books/#{book.id.to_s}/edit"
      fill_in "Title",	with: "Mysql Update"
      fill_in "Sort",	with: "1" 
      select('DB', from: 'book_category_id')
      select('IBM', from: 'book_author_ids')
      fill_in "Publish date",	with: "08/11/2021"
      
      click_button "Apply"
      expect(page).to have_text("Book was successfully updated.")
  end

  scenario "delete book" do
    book = FactoryBot.create :book
    book.save
    visit "/books"
      expect { click_link 'Destroy' }.to change(Book, :count).by(-1)
      expect(page).to have_text("Book was successfully destroyed.")
  end

  scenario "search book by keyword" do
    book = FactoryBot.create :book, title: 'ruby'
    book.save
    visit "/books"
      fill_in "keyword",	with: "ruby" 
      click_button "Search"
      expect(page).to have_text("ruby")
  end

end
