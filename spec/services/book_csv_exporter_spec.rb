
require 'rails_helper'

RSpec.describe BookCsvExporter, type: :model do

    include ActionDispatch::TestProcess::FixtureFile


    describe '#call' do

        context "test result after export" do
        
            let!(:params) { {csv_file: fixture_file_upload("book-sample-test-success.csv", "text/csv")} }
            
            it "should have title in csv" do
                csv_string = BookCsvExporter.new().call
                expect(csv_string).to include('id,title,publish_date,author,category')
            end

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

                csv_string = BookCsvExporter.new().call

                expect(csv_string).to include('Tender Is the Night')

            end

        end
    end

end