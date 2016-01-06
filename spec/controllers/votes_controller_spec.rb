require 'rails_helper'

RSpec.describe VotesController, type: :controller do
  let(:quote) { create(:quote) }
  let(:user) { create(:user) }
  let(:vote) { create(:vote, user: user, quote: quote) }

  describe "#create" do
    subject { post :create, params }
    context 'without a signed in user' do
      let(:params) { { quote_id: quote } }
      it { is_expected.to redirect_to new_user_session_path }
    end
    context "with a signed in user" do
      before { login_with user }
      context "with valid parameters" do
        let(:params) { { quote_id: quote.id, vote: attributes_for(:vote) } }
        it { is_expected.to redirect_to quotes_path }

        it "creates a vote associated with the user in the database" do
          expect { subject }.to change { user.votes(true).count }.from(0).to(1)
        end

        it "creates a vote in the database associated with the quote" do
          expect { subject }.to change { quote.votes(true).count }.from(0).to(1)
        end

        it "sets a flash notice" do
          subject
          expect(flash[:notice]).to include("Voted!")
        end
      end
      context "with invalid parameters" do
        let(:params) { { quote_id: quote.id, vote: { value: 55 } } }
        it { is_expected.to redirect_to quotes_path }

        it "sets a flash alert message" do
          subject
          expect(flash[:alert]).to include("Something")
        end

        it "doesn't create a vote" do
          expect { subject }.to change { Vote.count }.by(0)
        end
      end
    end
  end
end
