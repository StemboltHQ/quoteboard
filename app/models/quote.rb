class Quote < ActiveRecord::Base
  validates :body, presence: true

  belongs_to :created_by, class_name: :User, foreign_key: "user_id"

  has_many :votes, dependent: :destroy

  def score
    votes.sum(:value)
  end
end
