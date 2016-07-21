class Quote < ActiveRecord::Base
  validates :body, presence: true
  validates :person_id, presence: true

  belongs_to :created_by, class_name: :User, foreign_key: "user_id"
  belongs_to :person

  has_many :votes, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favouriting_users, through: :favourites, source: :user

  def score
    votes.sum(:value)
  end
end
