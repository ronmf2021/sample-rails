require 'rails_helper'

RSpec.describe UploadBookCsvForm, type: :model do
    
    include ActionDispatch::TestProcess::FixtureFile

    let!(:error_ext_params) { {csv_file: fixture_file_upload("book-sample-test.csv", "text/csv1")} }
    let!(:params) { {csv_file: fixture_file_upload("book-sample-test.csv", "text/csv")} }
    
    context "validation tests" do
        it "file should be presence with csv extention" do
            csv_upload_form = UploadBookCsvForm.new(error_ext_params)
            csv_upload_form.save
            expect(csv_upload_form.errors.messages[:base][0]).to eq("File require csv ext")
        end
    
        it "file should be return path after upload" do
            csv_upload_form = UploadBookCsvForm.new(params)
            csv_upload_form.save
            expect(csv_upload_form.path).to eq("public/upload/csv/book-sample-test.csv")
        end
    end

end