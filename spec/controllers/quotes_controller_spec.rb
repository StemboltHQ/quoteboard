require 'rails_helper'

RSpec.describe QuotesController, type: :controller do
  let(:user)     { create(:user) }
  let(:user_1)   { create(:user) }
  let(:quote)    { create(:quote, user:user) }

  describe "#new" do 
    context "with user not signed in" do
      it "redirects to sign in page" do
        get :new
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "with user signed in" do
      before { login_with user }
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end

      it "instantiates a new Quote variable" do
        get :new
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
        def valid_request
          post :create, quote: attributes_for(:quote)
        end
        
        it "changes the quotes count by +1" do
          expect { valid_request }.to change { Quote.count }.by(1)
        end

        it "redirects to the show page" do
          valid_request
          expect(response).to redirect_to quote_path(Quote.last)
        end
        it 'associates quote with creating user' do
          valid_request
          expect(Quote.last.user).to eq(user)
        end
      end

      context "with invalid parameters" do
        def invalid_request
          post :create, quote: attributes_for(:quote).merge({body: nil})
        end

        it "renders the new template filled" do
          invalid_request
          expect(response).to render_template(:new)
        end

        it "doesn't change the quotes count" do
          expect { invalid_request }.to_not change { Quote.count }
        end
      end
    end
  end
  describe "#edit" do
    context 'without user signed in' do
      it 'redirects to the sign in page' do
        get :edit, id: quote.id
        expect(response).to redirect_to new_user_session_path
      end
    end

    context 'with user signed in' do
      before { login_with user }
      context 'user owns the quote' do
        before { get :edit, id: quote.id }
        it 'renders the edit remplate' do
          expect(response).to render_template(:edit)
        end
        it 'instantiates the correct quote instance variable' do
          expect(assigns(:quote)).to eq(quote)
        end
      end
      context 'user doesn"t own the quote' do
        before { login_with user_1 }
        it "throws an error" do
          expect { get :edit, id: quote.id }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
  describe "#show" do
    context "without user signed in" do
      it 'redirects to the sign in page' do
        get :show, id: quote.id
        expect(response).to redirect_to new_user_session_path
      end
    end
    context 'with user signed in' do
      before { login_with user }  
      before { get :show, id: quote.id }

      it "renders the show template" do
        expect(response).to render_template(:show)
      end

      it "instantiates an instance variable with the passed id" do
        expect(assigns(:quote)).to eq(quote)
      end
    end
  end
  describe "#index" do
    context "without user signed in" do
      it "redirects to the sign in page" do
        get :index
        expect(response).to redirect_to new_user_session_path
      end
    end
    context "with user signed in" do
      before { login_with user }
      it "renders the index template" do
        get :index
        expect(response).to render_template(:index)
      end

      it "instantiates quotes variable which is all quotes" do
        quote
        quote_1 = create(:quote)
        get :index
        expect(assigns(:quotes)).to eq([quote, quote_1])
      end
    end
  end 
  describe "#create" do
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
          before { patch :update, id: quote.id, quote: { body: "hello" } }
          it 'updates the passed values in the database' do
            expect(quote.reload.body).to eq('hello')
          end
          it 'redirects to the show page' do
            expect(response).to redirect_to quote_path(quote)
          end
        end
        context 'with invalid update attributes' do
          before { patch :update, id: quote.id, quote: { body: nil } }
          it 'renders the edit template' do
            expect(response).to render_template :edit
          end
          it "doesn't update the database" do
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
