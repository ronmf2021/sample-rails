require 'csv'
require 'faker'

namespace :test do
  desc "create a sample csv book with large records"
  task create_sample_book_csv: :environment do
    headers = ['no', 'title', 'author', 'publish date', 'category']
    limit = 10000
    CSV.open("./book-sample-test.csv", "wb") do |csv|
        csv << headers
        (1..limit).each do |n|
            author_names = "#{Faker::Book.author}, #{Faker::Book.author}" 
            csv << [ n, Faker::Book.title, author_names, DateTime.now, Faker::Educator.subject ]
        end 
    end
    puts "file \e[42m#{'./book-sample-test.csv'}\e[0m \e[32m#{'created'}\e[0m"
  end

end
