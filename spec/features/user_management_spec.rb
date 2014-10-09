require 'spec_helper'
require_relative './helpers/session'

include SessionHelpers

feature "Users signs in" do
	
	scenario "when being logged out" do
		expect{sign_up }.to change(User, :count).by(1)
		expect(page).to have_content("Welcome, alice@example.com")  
		expect(User.first.email).to eq("alice@example.com")
	end

	scenario "with a password that doesnt match" do
		expect{ sign_up('a@a.com', 'pass', 'wrong') }.to change(User, :count).by(0)
		expect(current_path).to eq('/users')
    	expect(page).to have_content("Password does not match the confirmation")
	end

	scenario "with an email that is already registered" do
		expect{sign_up}.to change(User, :count).by(1)
		expect{sign_up}.to change(User, :count).by(0)
		expect(page).to have_content("This email is already taken")	
	end

	def sign_up (email = "alice@example.com", password = "oranges!", password_confirmation = "oranges!")
		visit '/users/new'
		expect(page.status_code).to eq(200)
		fill_in :email, :with => email
		fill_in :password, :with => password
		fill_in :password_confirmation, :with => password_confirmation
		click_button "Sign up"

	end
end

feature "Users signs in" do

	before(:each) do
		User.create(:email => "test@test.com",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario "with correct credentials" do
		visit '/'
		expect(page).not_to have_content("Welcome, test@test.com")
		sign_in('test@test.com', "test")
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "with incorrect credentials" do
	    visit '/'
	    expect(page).not_to have_content("Welcome, test@test.com")
	    sign_in('test@test.com', 'wrong')
	    expect(page).not_to have_content("Welcome, test@test.com")
  end

end

feature "User signs out" do

	before(:each) do
		User.create(:email => "test@test.com",
					:password => "test",
					:password_confirmation => "test")
	end

	scenario "while being signed in" do
		sign_in("test@test.com", "test")
		click_button "Sign out"
		expect(page).to have_content("Good bye!")
		expect(page).not_to have_content("Welcome, test@test.com")
	end 
end

feature "User resets password" do
	before(:each) do
		User.create(:email => "test@test.com",
					:password => "test",
					:password_confirmation => "test",
					:password_token => "WDJLPQWJVTIKYERBECGBJNSSZAXZXNMZEPWFDBSHPNDWBFHPRBBQGORKQTYYPTFU",
					:password_token_timestamp => Time.now)
	end

	scenario "with email" do
		visit '/users/forgotten'
		fill_in :email, :with => 'test@test.com'
		click_button("Reset") 
		expect(page).to have_content("We've just send you an email confirmation.")
	end

	scenario "with an incorrect email" do
		visit '/users/forgotten'
		fill_in :email, :with => 'a@a.com'
		click_button("Reset") 
		expect(page).not_to have_content("We've just send you an email confirmation.")
		expect(page).to have_content("The email entered is not correct.")
	end

	scenario "checks link in the email with the correct token" do
		visit '/users/reset_password/WDJLPQWJVTIKYERBECGBJNSSZAXZXNMZEPWFDBSHPNDWBFHPRBBQGORKQTYYPTFU'
		expect(page).to have_content("Reset Password")
	end

	scenario "checks link in the email with an incorrect token" do
		visit '/users/reset_password/:token'
		expect(page).not_to have_content("Reset Password")
		expect(page).to have_content("This token is not valid")
	end

	scenario "checks link in the email with correct token but a with invalid time" do
		User.create(:email => "test2@test.com",
					:password => "test2",
					:password_confirmation => "test2",
					:password_token => "12345678",
					:password_token_timestamp => Time.now - 60*60*2)


		visit '/users/reset_password/12345678'
		expect(page).not_to have_content("Reset Password")
		expect(page).to have_content("This token is not valid anymore.") 
	end

	scenario "user enters password in the 2 fields correctly" do
		visit '/users/reset_password/WDJLPQWJVTIKYERBECGBJNSSZAXZXNMZEPWFDBSHPNDWBFHPRBBQGORKQTYYPTFU'
		expect(page).to have_content("Reset Password")
		fill_in :password, :with => 'newpw'
		fill_in :password_confirmation, :with => 'newpw'
		click_button("Reset")
		expect(page).to have_content("Welcome, test@test.com")
	end

	scenario "user enters a password that doesnt match" do
		visit '/users/reset_password/WDJLPQWJVTIKYERBECGBJNSSZAXZXNMZEPWFDBSHPNDWBFHPRBBQGORKQTYYPTFU'
		expect(page).to have_content("Reset Password")
		fill_in :password, :with => 'newpw'
		fill_in :password_confirmation, :with => 'oldpw'
		click_button("Reset")
		expect(page).to have_content("Password does not match the confirmation")
	end

end




