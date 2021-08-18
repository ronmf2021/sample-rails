class CsvValidator < ActiveModel::Validator
    def validate(record)
        unless record.csv_file.nil?
            record.errors.add :base, "File require csv ext" if record.csv_file.content_type != "text/csv"
        end
    end
end

class UploadBookCsvForm

    include ActiveModel::Model

    attr_accessor :csv_file    
    
    validates :csv_file, presence: true
    validates_with CsvValidator
    
    attr_reader :path

    def save
        return unless valid?
        options = {
            :path => self.csv_file.path,
            :cols => {
                :title => 1,
                :publish_date => 3,
                :author => 2,
                :category => 4
            }
        }

        result = BookCsvImporter.new(options).call()
        self.errors.add :base, "File import failured" if result == false
        return result
    end

end