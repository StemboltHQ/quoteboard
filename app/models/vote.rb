class Vote < ActiveRecord::Base
  enum value: { hate_it: -2, dislike_it: -1, like_it: 1, love_it: 2 }

  validates :value, presence: true
  validates :user, uniqueness: { scope: :quote }

  belongs_to :user
  belongs_to :quote
end
