require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:quote) { FactoryGirl.create(:quote) }
  let(:user) { FactoryGirl.create(:user) }

  it { is_expected.to validate_presence_of(:body) }

  describe "#score" do
    number = I18n.t(:votes).keys.last
    before do
      create(:vote, value: 2, quote: nil)
      create(:vote, quote: quote, value: 2)
      create(:vote, quote: quote, value: 2, user: create(:user))
    end

    it "has a score function that tallies votes" do
      expect(quote.score).to eq(Vote.values[number] * 2)
    end
  end
end
