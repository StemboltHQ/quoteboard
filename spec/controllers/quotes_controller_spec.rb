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
  describe "#edit" do
  end
  describe "#show" do
    before { get :show, id: quote.id }

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "instantiates an instance variable with the passed id" do
      expect(assigns(:quote)).to eq(quote)
    end
  end
  describe "#index" do
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
