class Person < ActiveRecord::Base
  validates :slack_name, uniqueness: true, format: { with: /@.*/i, on: :save }, if: :slack_name
  validates :full_name, presence: true, unless: :slack_name
  has_many :quotes, dependent: :destroy

  def preferred_name
    full_name || slack_name
  end
end
