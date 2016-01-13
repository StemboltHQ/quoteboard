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
        let(:params) { { quote_id: quote.id, vote: { value: :i_am_indifferent } } }
        it "doesn't create a vote" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "#update" do
    subject { patch :update, params }
    context "without a signed in user" do
      let(:params) { { quote_id: quote.id, id: vote.id } }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "with a signed in user" do
      before { login_with user }
      context "with a user that owns the vote" do
        context "with a valid update value" do
          let(:params) { { quote_id: quote.id, id: vote.id, vote: { value: :love_it } } }
          it { is_expected.to redirect_to quotes_path }

          it "changes the vote value" do
            subject
            expect(vote.reload.value).to eq("love_it")
          end

          it "sets a flash notice" do
            subject
            expect(flash[:notice]).to include("Vote updated")
          end
        end
        context "with an invalid update value" do
          let(:params) { { quote_id: quote.id, id: vote.id, vote: { value: :unsure } } }

          it "doesn't change the vote value" do
            expect { subject }.to raise_error(ArgumentError)
          end
        end
      end
      context "with a user that doesn't own the vote" do
        before { login_with create(:user) }
        let(:params) { { quote_id: quote.id, id: vote.id, vote: { value: :love_it } } }

        it "raises an error" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "#destroy" do
    subject { delete :destroy, params }
    let(:params) { { quote_id: quote.id, id: vote.id } }
    context "without a signed in user" do
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "with a signed in user" do
      before { login_with user }
      context "user owns the vote" do
        it { is_expected.to redirect_to quotes_path }

        it "deletes the vote" do
          subject
          expect(Vote.find_by(id: vote.id)).to_not be
        end

        it "sets a notice" do
          subject
          expect(flash[:notice]).to include("Vote deleted")
        end
      end
      context "user doesn't own the vote" do
        before { login_with create(:user) }
        it "raises an error" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
