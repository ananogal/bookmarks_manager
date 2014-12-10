require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'rest-client'
require 'sinatra/partial'

require_relative 'data_mapper_setup'
require_relative 'controllers/application'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'helpers/application'
require_relative 'helpers/mailgun'

include Email

use Rack::Flash, :sweep =>true
enable :sessions
set :public_folder, 'public' 
set :partial_template_engine, :erb
