require 'rails_helper'

RSpec.describe QuotesController, type: :controller do
  let(:quote)    { create(:quote) }

  describe "#new" do 
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "instantiates a new Quote variable" do
      get :new
      expect(assigns(:quote)).to be_a_new Quote
    end
  end

  describe "#create" do
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
