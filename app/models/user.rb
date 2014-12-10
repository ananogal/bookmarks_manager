require 'bcrypt'

class User 
	include DataMapper::Resource

	validates_confirmation_of :password

	attr_reader :password
	attr_accessor :password_confirmation

	property :id, Serial
	property :email, String
	property :password_digest, Text
  property :password_token, Text, :default => " "
  property :password_token_timestamp, Time, :default => Time.now

  	validates_presence_of :email, :message => "Email not given"
  	validates_uniqueness_of :email, :message => "This email is already taken"

	def password=(password)
		  @password = password
    	self.password_digest = BCrypt::Password.create(password)
  end

	def self.authenticate(email, password)
		user = first(:email => email)
		if user && BCrypt::Password.new(user.password_digest) == password
			return user
		else
			return nil
		end
	end

	def self.createToken(email)
		user = User.first(:email => email)
		return nil if !user
		user.password_token = (1..64).map{('A'..'Z').to_a.sample}.join
    user.password_token_timestamp = Time.now
    user.save
    return user
	end 

	def self.resetPassword(token, password, passwordConfirmation)
		user = User.first(:password_token => token)
		return nil if !user

		user.password = password
		user.password_confirmation = passwordConfirmation
		user.save
		return user
	end
end
