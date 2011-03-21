class Episode < Sequel::Model
	one_to_many :videos
end
