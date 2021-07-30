json.extract! book, :id, :title, :sort, :author_id, :publish_date, :created_at, :updated_at
json.url book_url(book, format: :json)
