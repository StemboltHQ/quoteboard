require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:quote) { FactoryGirl.create(:quote) }
  let(:user) { FactoryGirl.create(:user) }
  let(:user_1) { FactoryGirl.create(:user) }

  it "requires a body" do
    quote.body = nil
    expect(quote).to be_invalid
  end

  it "has a score function that tallies votes" do
    num = Vote.values.values.last
    Vote.create(quote: nil, value: num)
    quote.votes.create(value: num, user: user)
    quote.votes.create(value: num, user: user_1)
    expect(quote.score).to eq(num * 2)
  end
end
