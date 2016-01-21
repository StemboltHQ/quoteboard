class Favourite < ActiveRecord::Base
  validates :user, presence: true
  validates :quote, presence: true, uniqueness: { scope: :user }

  belongs_to :user
  belongs_to :quote
end
