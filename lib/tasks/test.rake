require 'csv'
require 'faker'

namespace :test do
  desc "create a sample csv book with large records"
  task create_sample_book_csv: :environment do
    headers = ['no', 'title', 'author', 'publish date', 'category']
    limit = 10000
    
    #random categories
    categories = []
    (1..20).each do |n|
      categories << Faker::Educator.subject
    end

    #random authors
    authors = []
    (1..20).each do |n|
      authors << Faker::Book.author
    end

    CSV.open("./book-sample-test.csv", "wb") do |csv|
        csv << headers
        (1..limit).each do |n|
            csv << [ n, Faker::Book.title, authors.sample(1 + rand(2)).join(','), DateTime.now, categories.sample ]
        end 
    end
    puts "file \e[42m#{'./book-sample-test.csv'}\e[0m \e[32m#{'created'}\e[0m"
  end

end
