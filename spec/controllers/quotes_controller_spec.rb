require 'rails_helper'

RSpec.describe QuotesController, type: :controller do
  let(:user)     { create(:user) }
  let(:user_1)   { create(:user) }
  let(:quote)    { create(:quote, user: user) }

  describe "#new" do
    subject { get :new }
    context "with user not signed in" do
      it "redirects to sign in page" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
    context "with user signed in" do
      before { login_with user }
      it "renders the new template" do
        expect(subject).to render_template(:new)
      end

      it "instantiates a new Quote variable" do
        subject
        expect(assigns(:quote)).to be_a_new Quote
      end
    end
  end

  describe "#create" do
    context "without user signed in" do
      it 'redirects to sign in page' do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "with user signed in" do
      before { login_with user }
      context "with valid parameters" do
        subject { post :create, params }
        let(:params) { { quote: attributes_for(:quote) } }
        subject { post :create, quote: attributes_for(:quote) }

        it "changes the quotes count by +1" do
          expect { subject }.to change { Quote.count }.by(1)
        end

        it "redirects to the show page" do
          expect(subject).to redirect_to quote_path(Quote.last)
        end
        it 'associates quote with creating user' do
          subject
          expect(Quote.last.user).to eq(user)
        end
      end

      context "with invalid parameters" do
        subject { post :create, params }
        let(:params) { { quote: { body: nil } } }

        it "doesn't change the quotes count" do
          expect { subject }.to_not change { Quote.count }
        end

        it "renders the new template filled" do
          expect(subject).to render_template(:new)
        end

        it "doesn't change the quotes count" do
          expect { subject }.to_not change { Quote.count }
        end
      end
    end
  end

  describe "#edit" do
    subject { get :edit, id: quote.id }
    context 'without user signed in' do
      it 'redirects to the sign in page' do
        expect(subject).to redirect_to new_user_session_path
      end
    end
    context 'with user signed in' do
      before { login_with user }
      context 'user owns the quote' do
        it 'renders the edit template' do
          expect(subject).to render_template(:edit)
        end
        it 'instantiates the correct quote instance variable' do
          subject
          expect(assigns(:quote)).to eq(quote)
        end
      end
      context 'user doesn"t own the quote' do
        before { login_with user_1 }
        it "throws an error" do
          expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

  describe "#show" do
    subject { get :show, id: quote.id }
    context "without user signed in" do
      it 'redirects to the sign in page' do
        expect(subject).to redirect_to new_user_session_path
      end
    end
    context 'with user signed in' do
      before { login_with user }

      it "instantiates an instance variable with the passed id" do
        subject
        expect(assigns(:quote)).to eq(quote)
      end

      it "renders the show template" do
        expect(subject).to render_template(:show)
      end
    end
  end

  describe "#index" do
    subject { get :index }
    context "without user signed in" do
      it "redirects to the sign in page" do
        expect(subject).to redirect_to new_user_session_path
      end
    end
    context "with user signed in" do
      before { login_with user }
      it "renders the index template" do
        expect(subject).to render_template(:index)
      end
      it "instantiates a quotes variable containing all quotes" do
        subject
        expect(assigns(:quotes)).to eq([quote])
      end
    end
  end
  describe "#update" do
    context "without user signed in" do
      it "redirects to the sign in page" do
        post :create
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "with user signed in" do
      before { login_with user }
      context "with quote owner" do
        context 'with valid update attributes' do
          subject { patch :update, id: quote.id, quote: { body: "hello" } }
          it 'updates the passed values in the database' do
            subject
            expect(quote.reload.body).to eq('hello')
          end
          it 'redirects to the show page' do
            expect(subject).to redirect_to quote_path(quote)
          end
        end
        context 'with invalid update attributes' do
          subject { patch :update, id: quote.id, quote: { body: nil } }
          it 'renders the edit template' do
            expect(subject).to render_template :edit
          end
          it "doesn't update the database" do
            subject
            expect(quote.reload.body).to_not eq(nil)
          end
        end
      end
    end
  end
  describe "#delete" do
    context "without a signed in user" do
      it "redirects to the sign in page" do
        delete :destroy, id: quote.id
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "with a signed in user" do
      before { login_with user }
      context "with the user that owns the quote" do
        before { delete :destroy, id: quote.id }
        it 'redirects to the index page' do
          expect(response).to redirect_to quotes_path
        end
        it 'remove the quote from the database' do
          expect(Quote.find_by_id(quote.id)).to_not be
        end
      end
      context "with non owner logged in" do
        before { login_with user_1 }
        it 'throws an error' do
          expect { delete :destroy, id: quote.id }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end
  end
end
