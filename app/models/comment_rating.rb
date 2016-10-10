class CommentRating < ActiveRecord::Base
	belongs_to :app_user
	belongs_to :deal

	def app_user_name
	first_name = Base64.decode64(self.app_user.first_name) 
	last_name = Base64.decode64(self.app_user.last_name)
	full_name = first_name + " " + last_name
	full_name = Base64.encode64(full_name)
	end

	def app_user_image_url
		self.app_user.avatar.url
	end

	def comment_date
		self.created_at.strftime("%m/%d/%Y")
	end

	def as_json(opts={})
  		json = super(opts)
  		Hash[*json.map{|k, v| [k, v || ""]}.flatten]
	end
end
