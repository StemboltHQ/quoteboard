FactoryGirl.define do
  factory :quote do
    association :created_by, factory: :user
    quoted_person { Faker::Name.first_name }
    body { Faker::Lorem.sentences.join(" ") }
    location { Faker::Address.street_address }
  end
end
