class UserAddress < ActiveRecord::Base
  belongs_to :user

  validates :nickname, :uniqueness => true
  validates :nickname,:address1, :contact_number,:city_id,:city_location_id, :presence => true

  def self.search(params)
    conditions = []
    conditions << "status = '#{params[:status]}'" if params[:status].present?
    condition = conditions.join(' and ')
    self.where(condition)
  end
end
