require 'rails_helper'

RSpec.describe FavouritesController, type: :controller do
  let(:user) { create(:user) }
  let(:quote) { create(:quote) }
  let(:favourite) { create(:favourite, user: user, quote: quote) }

  describe "#create" do
    subject { post :create, params }
    context "without a logged in user" do
      let(:params) { { quote_id: quote.id } }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "with a logged in user" do
      before { login_with user }
      let(:params) { { quote_id: quote.id, user_id: user } }
      context "without having already favourited the quote" do
        it { is_expected.to redirect_to quotes_path }

        it "creates and associates the favourite with the user" do
          expect { subject }.to change { user.favourites.count }.from(0).to(1)
        end

        it "sets a flash message" do
          subject
          expect(flash[:notice]).to include("Favourited!")
        end
      end
      context "with having already favourited the quote" do
        before { create(:favourite, user: user, quote: quote) }
        it { is_expected.to redirect_to quotes_path }

        it "sets a flash message" do
          subject
          expect(flash[:alert]).to include("Failed")
        end

        it "Does not create a new favourite" do
          expect { subject }.to_not change { user.favourites.count }
        end
      end
    end
  end

  describe "#destroy" do
    subject { delete :destroy, params }
    context "without a logged in user" do
      let(:params) { { quote_id: quote, id: favourite.id } }
      it { is_expected.to redirect_to new_user_session_path }
    end

    context "with a logged in user" do
      before { login_with user }
      context "with a user that owns the favourite" do
        let(:params) { { quote_id: quote, id: favourite.id } }
        it { is_expected.to redirect_to quotes_path }

        it "deletes the vote" do
          subject
          expect(Favourite.find_by(id: favourite.id)).to be_nil
        end

        it "sets a flash notice" do
          subject
          expect(flash[:notice]).to include("Favourite removed.")
        end
      end
      context "with a user that doesn't own the favourite" do
        before { login_with create(:user) }
        let(:params) { { quote_id: quote.id, id: favourite.id } }
        it "raises an error" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "#favourite_quotes" do
    subject { get :favourite_quotes }
    context "without a logged in user" do
      it { is_expected.to redirect_to new_user_session_path }
    end
    context "with a logged in user" do
      before { login_with user }
      it { is_expected.to render_template(:favourite_quotes) }

      it "instantiates a variable containing all favourite quotes" do
        subject
        expect(assigns(:user_favourites)).to eq(user.favourite_quotes)
      end
    end
  end
end
