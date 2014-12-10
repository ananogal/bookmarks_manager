get '/users/new' do
	@user = User.new
	erb :"users/new"
end

post '/users' do
	@email = params[:email]

	if params[:password].empty?
		flash.now[:errors] =["No password entered"]
		erb :"users/new"
	else
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
end

get '/users/forgotten' do
	erb :"users/forgotten"
end

post '/users/forgotten' do
	@user = User.createToken(params[:email])
  if @user != nil 
    send_message(@user)
  else
		flash.now[:errors] = ["The email entered is not correct."]
	end
	
	erb :"users/forgotten"
end

get '/users/reset_password/:token' do
	@user = User.first(:password_token => params[:token])
	if !@user
		flash.now[:errors] = ["This token is not valid."]
	elsif @user.password_token_timestamp + 60*60 < Time.now
		flash.now[:errors] = ["This token is not valid anymore."]
	end
	@token = @user ? @user.password_token : "" 

	erb :"users/reset_password"
end

post '/users/reset_password' do
	if params[:password] == params[:password_confirmation] 
		@user = User.resetPassword(params[:token], params[:password], params[:password_confirmation])
		if @user
			session[:user_id] = @user.id
			redirect to'/'
		end
	else
		flash.now[:errors] = ["Password does not match the confirmation"]
		erb :"users/reset_password"
	end
end

