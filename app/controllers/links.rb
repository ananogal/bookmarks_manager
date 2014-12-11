get '/links/new' do
	erb :"links/new"
end

post '/links' do
	url = params[:url]
	title = params[:title]
	description = params[:description]
	tags = params[:tags].split(' ').map do |tag|
		Tag.first_or_create(:text => tag, :user_id => session[:user_id])
	end
	@link = Link.create(:url => url, :title => title, :tags => tags, 
											:user_id => session[:user_id], :description => description, 
											:created_at => DateTime.now)

	if @link.save
		redirect to('/')
	else
		flash.now[:errors] = @link.errors.full_messages
		erb :"links/new"
	end
end