# frozen_string_literal: true

class BookDecorator < Draper::Decorator
  delegate_all

  def author_names
    authors.map(&:name).join(', ')
  end

  def formated_publish_date
    publish_date&.strftime("%m/%d/%Y")
  end
end
