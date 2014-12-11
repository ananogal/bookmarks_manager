require 'spec_helper'

	feature "User browses the list of links" do
		before(:each) {
			@user = User.create(:email => "test@test.com",
					:username => 'Test',
					:password => 'test',
					:password_confirmation => 'test')

			sign_in('test@test.com', 'test')

			Link.create(:url => "http://www.makersacademy.com",
				:title => "Makers Academy",
				:user_id => @user.id,
				:tags => [Tag.first_or_create(:text => 'education', :user_id => @user.id)])
			Link.create(:url => "http://www.google.com",
				:title => "Google",
				:user_id => @user.id,
				:tags => [Tag.first_or_create(:text => 'search', :user_id => @user.id)])
			Link.create(:url => "http://www.bing.com",
				:title => "Bing",
				:user_id => @user.id,
				:tags => [Tag.first_or_create(:text => 'search', :user_id => @user.id)])
			Link.create(:url => "http://www.code.org",
				:title => "Code.org",
				:user_id => @user.id,
				:tags => [Tag.first_or_create(:text => 'education', :user_id => @user.id)])
		}

	scenario "when opening the home page" do 
		visit '/'
		expect(page).to have_content("Makers Academy")
	end

	scenario "filtered by a tag" do 
		visit '/tags/search'
		expect(page).not_to have_content("Code.org")
		expect(page).to have_content("Google")
		expect(page).to have_content("Bing")
	end
end