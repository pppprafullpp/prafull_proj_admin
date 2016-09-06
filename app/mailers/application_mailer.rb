class ApplicationMailer < ActionMailer::Base
  default from: APP_CONFIG[:from]
  layout 'mailer'
end
