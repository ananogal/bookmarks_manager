require_relative 'spec_helper'

describe Link, :focus => true do 

	context "Demonstration of how datamapper works" do
		before(:each) {
			@user = User.create(:email => "test@test.com",
					:username => 'Test',
					:password => 'test',
					:password_confirmation => 'test')

		}

		it "should be created and then retrieved from the db" do
			expect(Link.count).to eq(0)
			Link.create(:title => "Makers Academy",
				:url => "http://www.makersacademy.com/", :user_id=>@user.id)
			expect(Link.count).to eq(1)
			link = Link.first
			expect(link.url).to eq("http://www.makersacademy.com/")
			expect(link.title).to eq("Makers Academy")
			link.destroy
			expect(Link.count).to eq(0)
		end

	end

end