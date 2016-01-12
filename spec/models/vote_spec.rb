require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:vote) { create(:vote) }
  describe "validation" do
    it 'requires a value' do
      vote.value = nil
      expect(vote).to be_invalid
    end
  end
end
