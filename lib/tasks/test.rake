require 'csv'
require 'faker'

namespace :test do
  desc "create a sample csv book with large records"
  task csv_book: :environment do
    headers = ['no', 'title', 'author', 'publish date', 'category']
    limit = 10000
    csv_data = CSV.open("./book-test.csv", "wb") do |csv|
        csv << headers
        (1..limit).each do |n|
            csv << [ n, Faker::Book.title, Faker::Book.author, DateTime.now, rand(1...3) ]
        end 
    end
  end

end
