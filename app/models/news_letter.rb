class NewsLetter < ActiveRecord::Base
  validates :email,:uniqueness => true, presence: true
  validates_email_format_of :email, :message => 'not a valid email address'
end