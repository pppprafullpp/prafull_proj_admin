OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, '', '', {:client_options => {:ssl => {:ca_file => Rails.root.join("cacert.pem").to_s}},scope: 'email,public_profile,user_friends,user_birthday,manage_pages,publish_pages',display: 'page',info: 'birthday'}
end