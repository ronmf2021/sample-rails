require 'rails_helper'

RSpec.describe UploadBookCsvForm, type: :model do
    
    include ActionDispatch::TestProcess::FixtureFile

    context "validation tests" do
        
        let!(:error_params) { {csv_file: fixture_file_upload("book-sample-test-error.csv1", "text/csv1")} }
        let!(:params) { {csv_file: fixture_file_upload("book-sample-test-success.csv", "text/csv")} }

        it "file should be presence" do
            csv_upload_form = UploadBookCsvForm.new( {csv_file: nil} )
            csv_upload_form.save
            expect(csv_upload_form.errors.messages[:csv_file][0]).to eq("can't be blank")
        end

        it "file should has csv extention" do
            csv_upload_form = UploadBookCsvForm.new(error_params)
            csv_upload_form.save
            expect(csv_upload_form.errors.messages[:base][0]).to eq("File require csv ext")
        end
    
    end

end