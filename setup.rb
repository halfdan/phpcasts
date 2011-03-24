require 'rubygems'
require 'sequel'

DB = Sequel.connect('sqlite://phpcasts.db')

DB.create_table :episodes do
	primary_key :id
	String :name, :unique => true, :null => false
	String :permalink, :unique => true, :null => false
	Text :content	
	Boolean :published, :default => false
	Timestamp :published_at
	Timestamp :created_at
	Timestamp :updated_at
end

DB.create_table :videos do
	primary_key :id
	foreign_key :episode_id, :episodes, :key => :id
	String :format, :null => false
	String :filename, :null => false
end

DB.create_table :users do
	primary_key :id
	String :name, :unique => true, :null => false
	String :email
	String :github_uid
	String :github_username
	String :site_url
	String :gravatar_token
	Boolean :admin, :default => false
	Timestamp :created_at
	Timestamp :updated_at
end

DB.create_table :comments do
	primary_key :id
	foreign_key :user_id, :users, :key => :id
	Text :content
	Timestamp :created_at
	Timestamp :updated_at
end
