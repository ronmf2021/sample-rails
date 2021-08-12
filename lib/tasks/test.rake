require 'csv'
require 'faker'

namespace :test do
  desc "create a sample csv book with large records"
  task create_sample_book_csv: :environment do
    headers = ['no', 'title', 'author', 'publish date', 'category']
    limit = 10000
    csv_data = CSV.open("./book-test.csv", "wb") do |csv|
        csv << headers
        (1..limit).each do |n|
            csv << [ n, Faker::Book.title, Faker::Book.author, DateTime.now, Faker::Educator.subject ]
        end 
    end
  end

end
