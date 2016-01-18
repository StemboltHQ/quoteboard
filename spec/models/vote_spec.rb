require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { is_expected.to validate_presence_of(:value) }
end
