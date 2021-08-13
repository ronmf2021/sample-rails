require 'csv'

class BookCsvExporter

    def initialize(options = {})
        @options = options
    end
  
    def call
        CSV.generate do |csv|
            # header row
            csv << %w(id title publish_date author category)
            books_with_category_and_author.each do |item|
                csv << [item.id, item.title, item.publish_date, item[:author_names], item[:category_title] ]
            end
        end    
    end

    private

    def books_with_category_and_author
        Book.joins(:authors, :category)
            .select('books.id, books.title, books.publish_date, 
                GROUP_CONCAT(authors.name) as author_names, 
                categories.title as category_title')
            .group("books.id")
    end

end