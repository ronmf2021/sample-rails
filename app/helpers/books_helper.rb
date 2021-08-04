module BooksHelper

  def authors
    Author.all
  end

  # Author.all.collect { |c| [c.name, c.id] }
  #   => SELECT "authors".* FROM "authors"
  # Author.all.pluck(:name, :id)
  #   => SELECT "authors"."name", "authors"."id" FROM "authors"
  def author_options
    Author.all.pluck(:name, :id)
  end

  def category_options
    Category.all.pluck(:title, :id)
  end

  def author_names(authors)
    authors.pluck(:name).join(',')
  end
end
