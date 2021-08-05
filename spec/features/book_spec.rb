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

end
