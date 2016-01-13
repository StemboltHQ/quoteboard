require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:quote) { FactoryGirl.create(:quote) }
  let(:user) { FactoryGirl.create(:user) }

  it "requires a body" do
    quote.body = nil
    expect(quote).to be_invalid
  end

  describe "#score" do
    number = I18n.t(:votes).keys.last
    before do
      Vote.create(quote: nil, value: number)
      quote.votes.create(value: number, user: user)
      quote.votes.create(value: number, user: create(:user))
    end

    it "has a score function that tallies votes" do
      expect(quote.score).to eq(Vote.values[number] * 2)
    end
  end
end
