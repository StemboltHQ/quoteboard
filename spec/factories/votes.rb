FactoryGirl.define do
  factory :vote do
    value { :like_it }
    user
    quote
  end
end
