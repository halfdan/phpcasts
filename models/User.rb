class User < Sequel::Model
#	one_to_many :comments

	def self.create_from_omniauth(omniauth)
		user = User.new
		user.github_uid = omniauth["uid"]
		user.github_username = omniauth["user_info"]["nickname"]
		user.email = omniauth["user_info"]["email"]
		user.name = omniauth["user_info"]["name"]
		user.site_url = omniauth["user_info"]["urls"]["Blog"] if omniauth["user_info"]["urls"]
		user.gravatar_token = omniauth["extra"]["user_hash"]["gravatar_id"] if omniauth["extra"] && omniauth["extra"]["user_hash"]
		user.save
		return user
	end
end
