FactoryBot.define do

  factory :book do
    title { Faker::Name.name }
    sequence(:sort) 
    is_show { 1 }
    publish_date { DateTime.now }
    category { association :category }
  end

end
