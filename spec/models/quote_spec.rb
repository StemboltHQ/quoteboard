require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:quote) { FactoryGirl.create(:quote) }
  let(:user) { FactoryGirl.create(:user) }

  it "requires a body" do
    quote.body = nil
    expect(quote).to be_invalid
  end

  describe "#score" do
    before do
      Vote.create(quote: nil, value: 2)
      quote.votes.create(value: 2, user: user)
      quote.votes.create(value: 2, user: create(:user))
    end

    it "has a score function that tallies votes" do
      expect(quote.score).to eq(4)
    end
  end
end
