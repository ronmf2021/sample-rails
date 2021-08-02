FactoryBot.define do
  factory :book do
      title { "Ruby" }
      sort { 1 }
      publish_date { DateTime.parse('2021-08-02') }
  end
end
