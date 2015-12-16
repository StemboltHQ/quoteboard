require 'rails_helper'

RSpec.describe QuotesController, type: :controller do
  let(:quote)    { FactoryGirl.create(:quote) }

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

end
