require 'rails_helper'

RSpec.describe 'Admin User Show' do
  describe 'as an admin' do
    it 'sees the same info a user sees, without option to edit' do
      user = create(:user)
      create(:address, user: user)
      admin = create(:admin)

      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

      visit admin_user_path(user)

      within '#profile-data' do
        expect(page).to have_content("Role: #{user.role}")
        expect(page).to have_content("Email: #{user.email}")
        within '#address-details' do
          user.addresses.each do |address|
          expect(page).to have_content("Address: #{address.street_address}")
          expect(page).to have_content("#{address.city}, #{address.state} #{address.zip}")
          end
        end
        expect(page).to_not have_link('Edit Profile Data')
      end
    end
  end
end
