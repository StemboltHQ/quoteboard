class Quote < ActiveRecord::Base
  validates :body, presence: true
end
