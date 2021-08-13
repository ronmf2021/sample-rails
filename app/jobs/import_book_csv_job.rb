class ImportBookCsvJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    return if args[0].nil?
    options = {
      :path => args[0],
      :cols => {
        :title => 1,
        :publish_date => 3,
        :author => 2,
        :category => 4
      }
    }
    BookCsvImporter.new(options).call()
    File.delete(args[0]) if File.exist?(args[0])
    puts "[=======JOB DONE=======]:" << args[0]
  end
end
