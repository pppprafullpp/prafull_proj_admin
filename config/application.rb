require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Myapp
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    config.time_zone = 'New Delhi'
    config.assets.enabled = true
    #config.assets.paths << "#{Rails.root}/app/assets/fonts"
    # Version of your assets, change this if you want to expire all your assets
    #config.assets.version = '1.0'
    config.encoding = "utf-8"
    config.autoload_paths += %W(#{config.root}/lib)
    #config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    config.action_mailer.delivery_method = :smtp
     config.action_mailer.smtp_settings = {  
      :address              => "smtp.gmail.com",  
      :port                 => 587,
      :domain               => "",#"gmail.com",
      :user_name            => "",#"", #Your user name
      :password             => "", # Your password
      :authentication       => "plain",  
      :enable_starttls_auto => true  
   }
   
  end
end
