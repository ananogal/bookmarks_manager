require 'sinatra'
require 'data_mapper'
require 'rack-flash'

require './lib/link'
require './lib/tag'
require './lib/user'
require './data_mapper_setup'

use Rack::Flash, :sweep =>true

enable :sessions

get '/' do 
	@links = Link.all
	erb :index
end

post '/links' do
	url = params[:url]
	title = params[:title]
	tags = params[:tags].split(' ').map do |tag|
		Tag.first_or_create(:text => tag)
	end
	Link.create(:url => url, :title => title, :tags => tags)
	redirect to('/')
end

get '/tags/:text' do
	tag = Tag.first(:text => params[:text])
	@links = tag ? tag.links : []
	erb :index
end

get '/users/new' do
	@user = User.new
	erb :"users/new"
end

post '/users' do
	@email = params[:email]
	@user = User.create(:email => @email, 
						:password => params[:password], 
						:password_confirmation => params[:password_confirmation])

	if @user.save
		session[:user_id] = @user.id
		redirect to'/'
	else
		flash.now[:errors] = @user.errors.full_messages
		erb :"users/new"
	end
end

get '/sessions/new' do
	erb :"sessions/new"
end

post '/sessions' do
	email = params[:email]
	password = params[:password]
	user = User.authenticate(email, password)
	if user
		session[:user_id] = user.id
		redirect to('/')
	else
		flash[:errors] = ["The email or password is incorrect"]
		erb:"sessions/new"
	end
end

helpers do

  def current_user
    @current_user ||=User.get(session[:user_id]) if session[:user_id]
  end

end
