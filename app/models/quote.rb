class Quote < ActiveRecord::Base
  validates :body, presence: true

  belongs_to :created_by, class_name: :User, foreign_key: "user_id"

  has_many :votes, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favouriting_users, through: :favourites, source: :user

  def score
    votes.sum(:value)
  end
end
