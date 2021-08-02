class Book < ApplicationRecord
    
    belongs_to :category
    has_and_belongs_to_many :authors

    has_one_attached :image

    validates :title, presence: true, length: {maximum: 255}
    validates :sort, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }

    scope :find_by_category, ->( category_id ) { where(:category_id => category_id)}
    scope :find_by_keyword, ->( keyword ) { where("title like ?", "%" + keyword + "%") } 
    scope :find_by_publish_date, ->( publish_date ) { where('publish_date BETWEEN ? AND ?', Date.strptime(publish_date, "%m/%d/%Y").to_datetime.beginning_of_day, Date.strptime(publish_date, "%m/%d/%Y").to_datetime.end_of_day) }
    scope :find_by_author, ->( author_id ) { where("id in (select authors_books.book_id from authors_books where author_id = ?)", author_id) }


end
