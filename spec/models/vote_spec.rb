require 'rails_helper'

RSpec.describe Vote, type: :model do
  let(:user) { create(:user) }
  let(:quote) { create(:quote) }
  let(:vote) { create(:vote, user: user, quote: quote) }
  describe "validations" do
    it { is_expected.to validate_presence_of(:value) }

    describe "uniqueness of user scoped to quote" do
      subject { create(:vote) }

      it "doesn't allow someone to vote on a quote twice" do
        expect{ create(:vote, value: vote.value, user: user, quote: quote) }.
          to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
