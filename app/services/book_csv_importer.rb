require 'csv'

class BookCsvImporter

    def initialize(options = {})
        @options = options
    end
  
    def call
        ActiveRecord::Base.transaction do
            content = CSV.read(@options[:path])
            return if content.empty?
            # get and import category
            categories = categories_from_csv_content(content, categories_hash)
            import_categories(categories) if categories.length > 0
            # get and import author
            authors = authors_from_csv_content(content, authors_hash)
            import_authors(authors) if authors.length > 0
            # get and import book
            books = books_from_csv_content(content, categories_hash, authors_hash)
            import_books(books) if books.length > 0

            update_authors_books_table
        end
    end

    private 

    def categories_hash
        Category.all.pluck(:title, :id).to_h
    end

    def authors_hash
        Author.all.pluck(:name, :id).to_h
    end

    def categories_from_csv_content(content, categories_hash)
        categories = []
        content.each_with_index do |record, index|
            value = record[@options[:cols][:category]]
            next if index == 0 #skip title
            next if categories_hash.has_key?(value) #existed in database
            categories << value
        end
        
        sort = 0
        categories = categories.uniq.map do |item|
            sort += 1 
            [item, sort]
        end
        return categories
    end

    def import_categories(categories = [])
        columns = [ :title, :sort ]
        Category.import columns, categories, validate: false
    end

    def authors_from_csv_content(content, authors_hash)
        authors = []
        content.each_with_index do |record, index|
            next if index == 0 #skip title
            author_names(record[@options[:cols][:author]]).each do |value|
                next if authors_hash.has_key?(value) #existed in database
                authors << value
            end
        end
        return authors.uniq.map { |item| [item] }
    end

    def import_authors(authors = [])
        columns = [ :name ]
        Author.import columns, authors, validate: false
    end

    def author_names(col_val)
        return [] if col_val.nil? || col_val.empty?
        return col_val.split(',')
    end

    def books_from_csv_content(content, categories_hash, authors_hash)
        books = []
        content.each_with_index do |record, index|
            next if index == 0 #skip title
            title = record[@options[:cols][:title]]
            publish_date = record[@options[:cols][:publish_date]]
            category_title = record[@options[:cols][:category]]
            category_id = categories_hash[category_title]
            author_ids = []
            author_names(record[@options[:cols][:author]]).each do |author_name|
                author_ids << authors_hash[author_name]
            end
            books << [ title, publish_date, category_id, author_ids.join(',')  ]
        end
        return books
    end

    def import_books(books= [])
        columns = [ :title, :publish_date, :category_id, :authors_id ]
        Book.import columns, books, validate: false
    end

    def update_authors_books_table
        books = Book.where.not(authors_id: nil).pluck(:id, :authors_id)
        authors_books = []
        book_ids = []
        books.each do |book|
            next if book[1].nil?
            book_ids << book[0].to_i
            author_ids = book[1].split(',')
            author_ids.each do |author_id|
                authors_books << [book[0], author_id.to_i]
            end
        end
        columns = [ :book_id, :author_id ]
        AuthorsBooks.import columns, authors_books, validate: false
        # update authors_id to nil after import
        Book.where(id: book_ids).update_all(authors_id: nil)
    end
    
end