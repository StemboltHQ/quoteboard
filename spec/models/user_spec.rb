require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe 'validations' do
    it 'requires an email' do
      user.email = nil
      expect(user).to be_invalid
    end
  end
end
