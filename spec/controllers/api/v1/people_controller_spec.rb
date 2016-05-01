require 'rails_helper'

RSpec.describe Api::V1::PeopleController, type: :controller do
  let(:person) { create(:person) }

  describe '#create' do
    subject { post :create, params.merge(format: :json) }
    context 'with valid parameters' do
      let(:params) { { person: attributes_for(:person) } }
      it { is_expected.to render_template(:show) }

      it 'sets the correct status' do
        subject
        expect(response.status).to eq(201)
      end

      it 'create a person' do
        expect { subject }.to change { Person.count }.by(1)
      end
    end

    context 'with invalid parameters' do
      let(:params) { { person: { slack_name: "John" } } }

      it 'sets the correct status' do
        subject
        expect(response.status).to eq(400)
      end

      it 'does not create a person' do
        expect { subject }.to change { Person.count }.by(0)
      end
    end
  end
end
