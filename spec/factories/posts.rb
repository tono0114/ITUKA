FactoryBot.define do
  factory :post do
    title { Faker::Lorem.characters(number:10) }
    country { Faker::Lorem.characters(number:10) }
    text { Faker::Lorem.characters(number:20) }
    user
  end
end