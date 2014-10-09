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

get '/users/forgotten' do
	erb :"users/forgotten"
end

post '/users/forgotten' do
	@email = params[:email]
	@user = User.first(:email => @email)
    if @user 
        @user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
        @user.password_token_timestamp = Time.now
        @user.save
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
	@user = User.first(:password_token => params[:token])
	if params[:password] == params[:password_confirmation] 
		@user.password = params[:password]
		@user.password_confirmation = params[:password_confirmation]
		@user.save
		session[:user_id] = @user.id
		redirect to'/'
	else
		flash.now[:errors] = ["Password does not match the confirmation"]
		erb :"users/reset_password"
	end
end

