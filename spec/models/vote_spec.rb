require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:vote) { create(:vote, user: user) }
  describe "validations" do
    subject { vote }
    it { is_expected.to validate_uniqueness_of(:user_id).scoped_to(:quote_id) }
    it { is_expected.to validate_presence_of(:value) }
  end
end
