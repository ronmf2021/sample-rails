module DateHelper
    def date_from_sql_to_view(date, format)
        return '' if date.nil?
        return date.strftime(format)
    end
end