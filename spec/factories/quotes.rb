FactoryGirl.define do
  factory :quote do
    author Faker::Name.first_name
    body   Faker::Lorem.sentences
    location Faker::Address.street_address
  end

end