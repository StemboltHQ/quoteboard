class Person < ActiveRecord::Base
  validates :slack_name, uniqueness: true
  validates :full_name, presence: true
  has_many :quotes, dependent: :destroy
end
