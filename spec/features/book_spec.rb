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

  scenario "import success csv" do
    visit "/books/import"
      find('form input[type="file"]').set('spec/fixtures/files/book-sample-test-success.csv')
      click_button "Apply"
      expect(page).to have_text("Book was successfully imported.")
  end

  scenario "import failure csv" do
    visit "/books/import"
      find('form input[type="file"]').set('spec/fixtures/files/book-sample-test-failure.csv')
      click_button "Apply"
      expect(page).to have_text("File imported failure")
  end

  scenario "import without upload file" do
    visit "/books/import"
      click_button "Apply"
      expect(page).to have_text("can't be blank")
  end

  scenario "import error file" do
    visit "/books/import"
      find('form input[type="file"]').set('spec/fixtures/files/book-sample-test-error.csv1')
      click_button "Apply"
      expect(page).to have_text("File require csv ext")
  end

end
