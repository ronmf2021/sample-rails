FactoryBot.define do
  factory :author do
    name { Faker::Name.name }
    bday { DateTime.now }
  end
end
