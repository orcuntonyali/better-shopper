require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User location' do
    it 'retains the set location' do
      user = User.find_by(email: 'bettershopper@bettershopper.com')
      expected_location = 'Rudi-Dutschke-Straße 26, 10969 Berlin'

      expect(user.location).to eq(expected_location)
    end
  end
end
