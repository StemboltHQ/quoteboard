class Vote < ActiveRecord::Base
  VALID_VALUES = [-2, -1, 1, 2]
  VOTE_TYPES = [
    ["I hate it", -2].freeze,
    ["I'm against it", -1].freeze,
    ["I like it", 1].freeze,
    ["I love it", 2].freeze
  ].freeze

  validates :value, presence: true
  validates :user_id, uniqueness: { scope: :quote_id }
  validate :validate_value

  belongs_to :user
  belongs_to :quote

  def validate_value
    return true if VALID_VALUES.include? value
    errors.add(:value, "Invalid value entered")
  end
end
