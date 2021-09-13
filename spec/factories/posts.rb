FactoryBot.define do
  factory :post do
    image_id { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app/assets/images/post_no_image.png')) }
    title { Faker::Lorem.characters(number: 10) }
    country { Faker::Lorem.characters(number: 10) }
    text { Faker::Lorem.characters(number: 20) }
    user
  end
end