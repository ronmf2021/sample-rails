class CsvValidator < ActiveModel::Validator
    def validate(record)
        record.errors.add :base, "File require csv ext" unless record.csv_file.content_type == "text/csv"
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
        name = self.csv_file.original_filename
        @path = File.join("public", "upload", "csv", name)
        File.delete(@path) if File.exist?(@path)
        File.open(@path, "wb") { |f| f.write(self.csv_file.read) }
    end

end