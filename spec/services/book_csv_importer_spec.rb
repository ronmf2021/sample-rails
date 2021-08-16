
require 'rails_helper'

RSpec.describe BookCsvImporter, type: :model do

    include ActionDispatch::TestProcess::FixtureFile

    let!(:params) { {csv_file: fixture_file_upload("book-sample-test.csv", "text/csv")} }

    describe '#call' do

        context "test result after import" do
            
            it "should have data in DB" do
                csv_upload_form = UploadBookCsvForm.new(params)
                csv_upload_form.save
                options = {
                    :path => csv_upload_form.path,
                    :cols => {
                    :title => 1,
                    :publish_date => 3,
                    :author => 2,
                    :category => 4
                    }
                }
                BookCsvImporter.new(options).call

                expect(Book.count).to eq(5)
                
                expect(Category.where(title: 'Education').count).to eq(1)

                expect(Author.where(name: 'Mr. Ping Conroy').count).to eq(1)
            end

        end
    end

end