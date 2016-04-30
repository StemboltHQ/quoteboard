require 'rails_helper'

RSpec.describe Api::V1::QuotesController, type: :controller do
  let(:quote) { create(:quote) }

  describe '#create' do
    subject { post :create, params.merge(format: :json) }
    context 'with valid parameters' do
      let(:params) { { quote: attributes_for(:quote) } }
      it { is_expected.to render_template(:show) }

      it 'sets the correct status' do
        subject
        expect(response.status).to eq(201)
      end

      it 'creates a quote' do
        expect { subject }.to change { Quote.count }.by(1)
      end
    end

    context 'with invalid parameters' do
      let(:params)  { { quote: { body: nil } }  }

      it 'sets the correct status' do
        subject
        expect(response.status).to eq(400)
      end

      it 'does not create a quote' do
        expect { subject }.to change { Quote.count }.by(0)
      end
    end
  end
end
