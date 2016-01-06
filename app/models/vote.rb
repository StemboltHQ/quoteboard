class Vote < ActiveRecord::Base
  enum value: { hate_it: -2, against_it: -1, like_it: 1, love_it: 2 }

  validates :value, presence: true, inclusion: { in: Vote.values.keys }
  validates :user_id, uniqueness: { scope: :quote_id }

  belongs_to :user
  belongs_to :quote
end
