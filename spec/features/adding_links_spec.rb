require 'spec_helper'

feature 'User adds a new link' do 

	before(:each) do
		User.create(:email => "test@test.com",
					:username => 'Test',
					:password => 'test',
					:password_confirmation => 'test')
	end

	scenario 'if he has sign in' do
		visit '/'
		expect(page).not_to have_content('Add link')
		sign_in('test@test.com', 'test')
		expect(page).to have_content('Add link')
	end

	scenario "When browsing the homepage" do 
		sign_in('test@test.com', 'test')
		expect(Link.count).to eq(0)
		visit '/links/new'
		add_link("http://www.makersacademy.com/", "Makers Academy")
		expect(Link.count).to eq(1)
		link = Link.first
		expect(link.url).to eq("http://www.makersacademy.com/")
		expect(link.title).to eq("Makers Academy")
	end

	scenario "with no title" do
		expect(Link.count).to eq(0)
		visit '/links/new'
		add_link("http://www.makersacademy.com/", "")
		expect(Link.count).to eq(0)
		expect(page).to have_content("Title can't be empty")
	end

	scenario "with no url" do
		expect(Link.count).to eq(0)
		visit '/links/new'
		add_link("", "Makers Academy")
		expect(Link.count).to eq(0)
		expect(page).to have_content("Url can't be empty")
	end

	scenario "With a few tags" do 
		sign_in('test@test.com', 'test')
		visit '/links/new'
		add_link("http://www.makersacademy.com/",
			"Makers Academy",
			['education', 'ruby'])
		link = Link.first
		expect(Link.count).to eq(1)
		expect(link.tags.map(&:text)).to include('education')
		expect(link.tags.map(&:text)).to include("ruby")
	end

	def add_link(url, title, tags = [])
		within('#new-link') do
			fill_in 'url', :with => url
			fill_in 'title', :with => title
			fill_in 'tags', :with => tags.join(' ')
			fill_in 'description', :with => ''
			click_button 'Add Link'
		end
	end

end
