require 'rails_helper'

RSpec.describe ImportBookCsvJob, type: :job do
  
  context "test #perform" do
    
    it "should be have service call" do
      ActiveJob::Base.queue_adapter = :test
      expect {
        ImportBookCsvJob.perform_later('public/upload/csv/book-sample-test.csv')
      }.to have_enqueued_job

    end

  end
  
end
