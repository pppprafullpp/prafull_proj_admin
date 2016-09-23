class ChannelPackage < ActiveRecord::Base
  validates_uniqueness_of :package_code
  before_save :update_channel_count

  def channel_name
    Channel.select('id,channel_name').where(id: eval(self.channel_ids))
  end


  private
  def update_channel_count
    self.channel_count = eval(self.channel_ids).count - 1 if self.channel_ids.present?
  end
end
