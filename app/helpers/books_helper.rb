module BooksHelper

    def authors
        Author.all
    end

    def author_options
        Author.all.collect { |c| [c.name, c.id] }.insert(0, ["--Choose author--", 0])
    end

    def category_options
        Category.all.collect { |c| [c.title, c.id] }.insert(0, ["--Choose category--", 0])
    end

    def category_title(category)
        return category.title unless category.nil? 
        return ''
    end

    def author_names(authors)
        return authors.map { |a| a.name }.join(',') unless authors.nil?
        ''
    end

    def category_id_by_book(book)
        return book.category.id unless book.category.nil?
        0
    end

end
