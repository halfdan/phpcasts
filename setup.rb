require 'rubygems'
require 'sequel'

DB = Sequel.connect('sqlite://phpcasts.db')

DB.create_table :episodes do
	primary_key :id
	String :name
	String :content
	DateTime :created_at
	Boolean :published
	DateTime :published_at
end

DB.create_table :videos do
	primary_key :id
	foreign_key(:episode_id, :episodes, :key=>:id)
	String :format
	String :filename
end
