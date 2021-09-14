FactoryBot.define do
  factory :user do
    image_id { Rack::Test::UploadedFile.new(File.join(Rails.root, 'app/assets/images/user_no_image.png')) }
    name { Faker::Lorem.characters(number: 10) }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
