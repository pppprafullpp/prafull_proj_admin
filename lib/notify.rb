module Notify
  ## loading app_config again here bcos rake task is not able to load yml file
  APP_CONFIG = YAML.load_file("#{Rails.root}/config/instances/servicedeals.yml")[Rails.env]
  require "sms_owl"
  SMS_OWL_ACCOUNT_ID = APP_CONFIG[:smsowl][:accountid]
  SMS_OWL_API_KEY = APP_CONFIG[:smsowl][:apikey]
  SENDER_ID = ''## configure your sender id provided by thirdparty

  def notify(object,class_name,notification_name,sms = false,options)
    if options[:email]
      if options[:password].present?
        Email.send_welcome_email(object,class_name,notification_name,options[:password])
      else
        Email.send_email(object,class_name,notification_name)
      end
    end
    Sms.send_sms(object,class_name,notification_name) if sms
  end

  class Email
    ## generic function to route all emails ##
    def self.send_welcome_email(object,class_name,notification_name,password)
        # byebug
      eval(class_name.name + '::' +class_name.name + 'Mailer').send(notification_name + '_email',object,password).deliver
    end

    def self.send_email(object,class_name,notification_name)
      eval(class_name + '::' +class_name + 'Mailer').delay.send(notification_name + '_email',object)
    end

  end

  class Sms
    ## generic function to route all SMS ##
    def self.send_sms(object,class_name,notification_name)
      sms_id = ''
      smsOwl = SmsOwl.new(SMS_OWL_ACCOUNT_ID, SMS_OWL_API_KEY)
      message,mobile = eval(class_name + 'Sms').send(notification_name + '_sms',object)
      begin
        mobile = mobile.present? ? mobile : object.mobile
        ### promotional sms sent on low priority only between 9:30 AM to 8:30 PM and not on DND numbers
        if (Time.now.strftime('%H:%m') > '09:30'.to_datetime.strftime('%H:%m') and Time.now.strftime('%H:%m') < '20:30'.to_datetime.strftime('%H:%m'))
          if message.present? and mobile.present?
            if mobile.kind_of?(Array)
              mobile.each_slice(10).to_a.each do |m|
                receivers = m.collect {|x| '+91' + x.to_s }
                sms_id = smsOwl.delay.sendPromotionalSms(SENDER_ID, "#{receivers}", "#{message}", SmsOwl::SmsType::NORMAL) if receivers.present?
              end
            else
              sms_id = smsOwl.delay.sendPromotionalSms(SENDER_ID, "+91#{mobile}", "#{message}", SmsOwl::SmsType::NORMAL)
            end
          end
        end
        ### transactional sms sent on high priority line anytime and on DND numbers as well
        ##sms_id = smsOwl.delay.sendTransactionalSms(SENDER_ID, "+91#{mobile}", "#{message}", SmsOwl::SmsType::NORMAL) if mobile.present?
        ##puts "***************#{sms_id}******************"
          ## TODO wecan track messages by storing this id in db ##
      rescue Exception => e
        Admin::AdminMailer.delay.exception_mail(sms_id,e)
      end
    end
  end

  class UserSms
    def self.welcome_sms(user)
      login = user.email.present? ? user.email : user.mobile
      password = user.password
      return "Welcome #{user.first_name} to Service Deals.com, your login id is #{login} & password is #{password}"
    end

    def self.generate_otp_sms(user)
      otp = user.otp
      return "Hi #{user.first_name}, your OTP is #{otp}, have a nice day from Service Deals." if otp.present?
    end

  end

  class AdminSms
    def self.welcome_sms(admin)
      login = admin.email.present? ? admin.email : admin.mobile
      password = admin.password
      return "Welcome #{admin.name} to Service Deals.com, your login id is #{login} & password is #{password}"
    end
  end

end
