require 'rubygems'
require 'sinatra'
require 'sequel'
require 'haml'

configure do
	Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://phpcasts.db')

	require 'ostruct'
	PHPCast = OpenStruct.new(
		:title => 'PHPcasts',
		:author => 'Fabian Becker',
		:url_base => 'http://localhost:4567/',
		:admin_password => 'changeme',
		:admin_cookie_key => 'phpcasts_admin',
		:admin_cookie_value => '51d6d976913ace58'
	)
end

# Load Models
require 'models/Episode.rb'
require 'models/Video.rb'

layout 'layout'

get '/' do
	episodes = Episode.order(:created_at.desc).all
	haml :main, :locals => { :episodes => episodes }
end

get '/episode/:id' do
	episode = Episode.filter(:id => params[:id]).first
	haml :episode, :locals => { :episode => episode }
end

get '/about' do
	haml :about
end
