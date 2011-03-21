class Video < Sequel::Model
	many_to_one :episode
end
