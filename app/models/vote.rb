class Vote < ActiveRecord::Base
  VALID_VALUES = [-2, -1, 1, 2]

  validates :value, presence: true
  validate :validate_value

  belongs_to :user
  belongs_to :quote

  def validate_value
    return true if VALID_VALUES.include? value
    errors.add(:value, "Invalid value entered")
  end
end
