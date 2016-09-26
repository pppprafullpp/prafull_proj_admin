class SubscribeDeal < ActiveRecord::Base
	belongs_to :app_user
	belongs_to :deal
	
	def as_json(opts={})
    	json = super(opts)
    	Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  	end
end
