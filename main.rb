require 'rubygems'
require 'sinatra'
require 'sequel'
require 'haml'
require 'omniauth'
require 'rack-flash'
require 'lib/partial'

configure do
	Sequel.connect(ENV['DATABASE_URL'] || 'sqlite://phpcasts.db')

	require 'ostruct'
	PHPCast = OpenStruct.new(
		:title => 'PHPcasts',
		:author => 'Fabian Becker',
		:url_base => 'http://phpcasts.net',
		:github_id => 'github_id',
		:github_secret => 'github_secret'
	)
end

enable :sessions

use OmniAuth::Builder do
	# Sign up at https://github.com/account/applications
	provider :github, PHPCast.github_id, PHPCast.github_secret
end

helpers do
	include Rack::Utils
	alias_method :h, :escape_html

	include Sinatra::Partials

	use Rack::Flash

	# url_escape helper
	def u(url)
		CGI.escape url
	end

	def is_logged_in?
		session[:logged_in] == true
	end

	def is_admin?
		is_logged_in? && @current_user.is_admin?
	end

	def username
		session[:username]
	end

	def current_url
		request.url
	end
end

# Load Models
require 'models/Episode.rb'
require 'models/Video.rb'
require 'models/User.rb'
require 'models/Comment.rb'

layout 'layout'

before do
	@current_user = User.filter(:id => session[:user_id]).first if is_logged_in?
end

get '/' do
	@page = params[:page] ? params[:page].to_i : 1
	@episodes = Episode.order(:created_at.desc).limit(10, (@page-1)*10)
	haml :episodes
end

get '/episode/:id' do
	@episode = Episode.filter(:id => params[:id]).first
	haml :episode
end

get '/login' do
	session[:return_to] = params[:return_to] if params[:return_to]
	redirect '/auth/github'
end

get '/logout' do
	session[:logged_in] = false	
end

get '/auth/:name/callback' do
	auth = request.env['omniauth.auth']
	# do whatever you want with the information!
	@current_user = User.filter(:github_uid => auth["uid"]).first || User.create_from_omniauth(auth)
	session[:user_id] = @current_user.id
	session[:logged_in] = true
	flash[:notice] = "You successfully logged in!"
	redirect (!session[:return_to].nil? && session[:return_to]) || PHPCast.url_base
end


get '/about' do
	haml :about
end

get '/feed.rss' do
	episodes = Episode.filter(:published => true).order(:created_at.desc).all
	haml :feed, :locals => {:episodes => episodes}, :layout => false
end

not_found do
	haml :notfound
end

error do
	haml :error
end
