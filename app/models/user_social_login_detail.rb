class UserSocialLoginDetail < ActiveRecord::Base
  #belongs_to :user

  ## FACEBOOK OMNIAUTH ##
  def self.from_omniauth(auth)
    #where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
    where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
      return user,auth.info.email,auth.info.image
    end
  end

end
