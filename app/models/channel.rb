class Channel < ActiveRecord::Base
  validates_uniqueness_of :channel_name, :channel_code

  mount_uploader :image, ChannelpicUploader
  validates_size_of :image,  :maximum => 1.megabytes.to_i, :message => "Image size should be less than 1 MB"


  CATEGORIES = ['Sports','News','Entertainment','Movies','Knowledge','Cartoon','Rituals','Music & Audio','Regional','Others']
  CHANNEL_TYPES = ['normal','adult','children']

  def self.get_channels
    self.where(:status => true)
  end
 
end
