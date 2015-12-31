require 'rails_helper'

RSpec.describe Quote, type: :model do
  let(:quote) { FactoryGirl.create(:quote) }

  it "requires a body" do
    quote.body = nil
    expect(quote).to be_invalid
  end
end
