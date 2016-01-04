FactoryGirl.define do
  factory :vote do
    value { 1 }
    user
    quote
  end
end
