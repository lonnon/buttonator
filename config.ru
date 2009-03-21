require 'vendor/rack/lib/rack'
require 'vendor/sinatra/lib/sinatra'

set :run, false
set :environment, :production
set :views, "views"

require 'buttonator.rb'
run Sinatra::Application
