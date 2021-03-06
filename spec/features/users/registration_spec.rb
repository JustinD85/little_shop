require 'rails_helper'

RSpec.describe 'the registration page' do
  describe 'happy path' do
    it "should create a new user after filling out the form" do
      visit registration_path

      fill_in :user_name, with: "name"
      fill_in :user_email, with: "example@gmail.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"
      fill_in 'Street address', with: "address"
      fill_in 'Nickname', with: "oranges"
      fill_in 'City', with: "city"

      fill_in 'State', with: "state"
      fill_in 'Zip', with: "zip"

      click_button "Submit"

      expect(current_path).to eq(profile_path)

      user = User.last

      expect(page).to have_content("Registration Successful! You are now logged in.")
      expect(page).to have_content("Logged in as #{user.name}")
    end
  end

  describe 'sad path' do
    it "should display error messages for each unfilled field" do
      visit registration_path

      click_button "Submit"

      expect(current_path).to eq(registration_path)

      expect(page).to have_content("Password can't be blank")
      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Addresses street address can't be blank")
      expect(page).to have_content("Addresses city can't be blank")
      expect(page).to have_content("Addresses state can't be blank")
      expect(page).to have_content("Addresses zip can't be blank")
      expect(page).to have_content("Email can't be blank")
    end

    it "should display an error when an email is taken" do
      user = create(:user)
      user.update(email: "example@gmail.com")

      visit registration_path

      fill_in :user_name, with: "name_1"
      fill_in :user_email, with: "example@gmail.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "password"
      fill_in 'Street address', with: "address_1"
      fill_in 'City', with: "city_1"
      fill_in 'State', with: "state_1"
      fill_in 'Zip', with: "zip_1"
      fill_in 'Nickname', with: "Oranges"

      click_button "Submit"

      expect(current_path).to eq(registration_path)
      expect(page).to have_content("Email has already been taken")
      expect(page).to have_css("input[value='name_1']")
      expect(page).to have_css("input[value='address_1']")
      expect(page).to have_css("input[value='home']")
      expect(page).to have_css("input[value='city_1']")
      expect(page).to have_css("input[value='state_1']")
      expect(page).to have_css("input[value='zip_1']")
      expect(page).to_not have_css("input[value='example@gmail.com']")
      expect(page).to_not have_css("input[value='password']")
    end

    it "should display an error when password confirmation doesn't match" do
      visit registration_path

      fill_in :user_name, with: "name"
      fill_in :user_email, with: "example@gmail.com"
      fill_in :user_password, with: "password"
      fill_in :user_password_confirmation, with: "a different password"
      fill_in 'Street address', with: "address"
      fill_in 'City', with: "city"
      fill_in 'State', with: "state"
      fill_in 'Zip', with: "zip"

      click_button "Submit"

      expect(current_path).to eq(registration_path)
      expect(page).to have_content("Password confirmation doesn't match Password")
    end
  end
end
