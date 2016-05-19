FactoryGirl.define do
  factory :quote do
    association :created_by, factory: :user
    association :person
    quoted_person { Faker::Name.name }

    body { Faker::Lorem.sentences.join(" ") }
    location { Faker::Address.street_address }
  end
end
