class Deal < ActiveRecord::Base
  belongs_to :service_category
  belongs_to :service_provider
  has_many :comment_ratings, dependent: :destroy
  has_many :subscribe_deals, dependent: :destroy
  has_many :trending_deals, dependent: :destroy
  has_many  :internet_deal_attributes, dependent: :destroy
  has_many  :telephone_deal_attributes, dependent: :destroy
  has_many  :cable_deal_attributes, dependent: :destroy
  has_many  :cellphone_deal_attributes, dependent: :destroy
  has_many  :bundle_deal_attributes, dependent: :destroy
  has_many  :additional_offers, dependent: :destroy
  has_many  :deal_include_zipcodes, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :order_items, dependent: :destroy
  has_many :deal_extra_services, dependent: :destroy

  has_many :cable_equipments, dependent: :destroy
  has_many :cellphone_equipments, dependent: :destroy
  has_many :bundle_equipments, dependent: :destroy
  has_many :internet_equipments, dependent: :destroy
  has_many :telephone_equipments, dependent: :destroy
  has_and_belongs_to_many  :zipcodes, dependent: :destroy

  accepts_nested_attributes_for :internet_deal_attributes,:reject_if => :reject_internet, allow_destroy: true
  accepts_nested_attributes_for :telephone_deal_attributes,:reject_if => :reject_telephone, allow_destroy: true
  accepts_nested_attributes_for :cable_deal_attributes,:reject_if => :reject_cable, allow_destroy: true
  accepts_nested_attributes_for :cellphone_deal_attributes,:reject_if => :reject_cellphone, allow_destroy: true
  accepts_nested_attributes_for :bundle_deal_attributes,:reject_if => :reject_bundle, allow_destroy: true
  accepts_nested_attributes_for :additional_offers,:reject_if => :reject_additional, allow_destroy: true
  accepts_nested_attributes_for :deal_include_zipcodes,:reject_if => :reject_include_zipcodes, allow_destroy: true

  # mount_uploader :image, ImageUploader

  validates_presence_of :service_category_id, :title, :short_description, :detail_description, :price, :url, :start_date, :end_date, :image
  before_save :update_effective_price
  ### CONSTANTS ###
  INTERNET_CATEGORY = 1
  TELEPHONE_CATEGORY = 2
  CABLE_CATEGORY = 3
  CELLPHONE_CATEGORY = 4
  BUNDLE_CATEGORY = 5

  #def as_json(opts={})
  #	json = super(opts)
  # Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  #end

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
    #deal_hash = row.to_hash # exclude the price field
    deal_hash = { :id => row['ID'],
                  :service_category_id => row['Service Category ID'],
                  :service_provider_id => row['Service Provider ID'],
                  :title => row['Title'],
                  :state => row['State'],
                  :city => row['City'],
                  :zip => row['Zip'],
                  :price => row['Price'],
                  :upload_speed => row['Upload Speed'],
                  :download_speed => row['Download Speed'],
                  :free_channels => row['Free Channels'],
                  :premium_channels => row['Premium Channels'],
                  :data_plan => row['Data Plan'],
                  :data_speed => row['Data Speed'],
                  :domestic_call_minutes => row['Domestic Call Minutes'],
                  :international_call_minutes => row['International Call Minutes'],
                  :domestic_call_unlimited => row['Domestic Call Unlimited'],
                  :international_call_unlimited => row['International Call Unlimited'],
                  :bundle_combo => row['Bundle Combo'],
                  :is_active => row['Is Active'],
                  :url => row['URL'],
                  :start_date => row['Start Date'],
                  :end_date => row['End Date'],
                  :short_description => row['Short Description'],
                  :detail_description => row['Detail Description'],
                  :image => row['Image'],
                  :created_at => row['Created At'],
                  :updated_at => row['Updated At'],
    }
    deal = Deal.where(id: deal_hash[:id])

    if deal.count == 1
      deal.first.update_attributes(deal_hash.except("image"))
    else
      Deal.create!(deal_hash)
    end # end if !service_category.nil?
  end # end CSV.foreach
end # end self.import(file)

def order_status
  order = OrderItem.select('status').where(deal_id: self.id).first.status
  return order
end

def deal_image_url
  image.url
end

def channel_packages
  channel_packages = ChannelPackage.where(service_provider_id: self.service_provider_id)
  return channel_packages
end

#def deal_image=(obj)
#	super(obj)
#	# Put your callbacks here, e.g.
#	self.moderated = false
#end
def bundle_combo
  self.bundle_deal_attributes.present? ? self.bundle_deal_attributes.first.bundle_combo : ""
end

def average_rating
  if self.comment_ratings.present?
    self.comment_ratings.average(:rating_point).to_f.round(2)
  else
    return 0
  end
end

def rating_count
  self.comment_ratings.count
end

def deal_price
  sprintf '%.2f', self.price if self.price.present?
end

def update_effective_price
  self.effective_price = get_effective_price
end

# previously we are calculating effective price on runtime
# now effective price is calculated on deal creation itself so making this fucntion as deprecated
def effective_price_bck
  effective_price = get_effective_price
  if effective_price != self.deal_price.to_f
    effective_price = effective_price.present? ? effective_price : 0
    sprintf '%.2f', effective_price
  else
    deal_price = self.deal_price.present? ? self.deal_price : 0
    sprintf '%.2f', deal_price.to_f
    #effective_price=0
  end
end

def get_effective_price
  if self.internet_deal_attributes.present?
    internet=self.internet_deal_attributes.first
    equipment=internet.internet_equipments.first
    effective_price=self.deal_price.to_f
    if equipment.present?
      effective_price+=equipment.price
    end
    if self.additional_offers.present?
      self.additional_offers.each do |additional_offer|
        effective_price-=additional_offer.price
      end
    end
  elsif self.telephone_deal_attributes.present?
    telephone=self.telephone_deal_attributes.first
    equipment=telephone.telephone_equipments.first
    effective_price=self.deal_price.to_f
    if equipment.present?
      effective_price+=equipment.price
    end
    if self.additional_offers.present?
      self.additional_offers.each do |additional_offer|
        effective_price-=additional_offer.price
      end
    end
  elsif self.cable_deal_attributes.present?
    cable=self.cable_deal_attributes.first
    equipment=cable.cable_equipments.first
    effective_price=self.deal_price.to_f
    if equipment.present?
      effective_price+=equipment.price
    end
    if self.additional_offers.present?
      self.additional_offers.each do |additional_offer|
        effective_price-=additional_offer.price
      end
    end
  elsif self.cellphone_deal_attributes.present?
    cellphone_attributes = self.cellphone_deal_attributes.where(:no_of_lines => 2).first
    cellphone = cellphone_attributes.present? ? cellphone_attributes : self.cellphone_deal_attributes.first
    equipment=cellphone.cellphone_equipments.first
    effective_price=(cellphone.no_of_lines*cellphone.price_per_line)+cellphone.data_plan_price+cellphone.additional_data_price
    if equipment.present?
      effective_price+=(cellphone.no_of_lines*equipment.price)
    end
    if self.additional_offers.present?
      self.additional_offers.each do |additional_offer|
        effective_price-=additional_offer.price
      end
    end
  elsif self.bundle_deal_attributes.present?
    bundle=self.bundle_deal_attributes.first
    equipment=bundle.bundle_equipments.first
    effective_price=self.deal_price.to_f
    if equipment.present?
      effective_price+=equipment.price
    end
    if self.additional_offers.present?
      self.additional_offers.each do |additional_offer|
        effective_price-=additional_offer.price
      end
    end
  end
  if effective_price != self.deal_price.to_f
    effective_price
  else
    self.deal_price.to_f
    #effective_price=0
  end
end

def service_category_name
  self.service_category.name
end

def service_provider_name
  self.service_provider.name
end

def deal_additional_offers
  self.additional_offers if self.additional_offers.present?
end

def deal_equipments
  category_name = ServiceCategory.get_category_name_by_id(self.service_category_id)
  if category_name.present?
    eval("#{category_name}_equipments".tableize).where(:deal_id => self.id)
  else
    []
  end
end

def deal_attributes
  category_name = ServiceCategory.get_category_name_by_id(self.service_category_id)
  if category_name.present?
    eval("#{category_name}_deal_attributes".tableize).where(:deal_id => self.id)
  else
    []
  end
end


## commenting this function as now equipments are linked with deals
def deal_equipments_bck
  if self.internet_deal_attributes.present?
    self.internet_deal_attributes.first.internet_equipments if self.internet_deal_attributes.first.internet_equipments.present?
  elsif self.telephone_deal_attributes.present?
    self.telephone_deal_attributes.first.telephone_equipments if self.telephone_deal_attributes.first.telephone_equipments.present?
  elsif self.cable_deal_attributes.present?
    self.cable_deal_attributes.first.cable_equipments if self.cable_deal_attributes.first.cable_equipments.present?
  elsif self.cellphone_deal_attributes.present?
    self.cellphone_deal_attributes.first.cellphone_equipments if self.cellphone_deal_attributes.first.cellphone_equipments.present?
  elsif self.bundle_deal_attributes.present?
    self.bundle_deal_attributes.first.bundle_equipments if self.bundle_deal_attributes.first.bundle_equipments.present?
  end
end

def self.build_custom_json(order_id)
  order_items_array = []
  order_items = OrderItem.where(:order_id => order_id)
  order_items.each do |order_item|
    order_items_hash = {}
    order_items_hash['deal'] = {}
    order_items_hash['deal']['deal_equipments'] = []
    #order_items_hash['deal']['deal_attributes']['deal_equipments'] = {}
    category = ServiceCategory.select(" distinct name").joins(:deals).where("deals.id = ?",order_item.deal_id).first.name.downcase
    order_items_hash['id'] = order_item.id
    order_items_hash['order_id'] = order_item.order_id
    order_items_hash['deal_id'] = order_item.deal_id
    order_items_hash['deal_price'] = order_item.deal_price
    order_items_hash['effective_price'] = order_item.effective_price
    order_items_hash['activation_date'] = order_item.activation_date
    order_items_hash['status'] = order_item.status
    order_items_hash['you_save'] = order_item.you_save
    deal = order_item.deal
    order_items_hash['deal']['id'] = deal.id
    order_items_hash['deal']['service_category_id'] = deal.service_category_id
    order_items_hash['deal']['service_provider_id'] = deal.service_provider_id
    order_items_hash['deal']['title'] = deal.title
    order_items_hash['deal']['short_description'] = deal.short_description
    order_items_hash['deal']['detail_description'] = deal.detail_description
    order_items_hash['deal']['price'] = deal.price
    order_items_hash['deal']['is_contract'] = deal.is_contract
    order_items_hash['deal']['contract_period'] = deal.contract_period
    order_items_hash['deal']['url'] = deal.url
    order_items_hash['deal']['start_date'] = deal.start_date
    order_items_hash['deal']['end_date'] = deal.end_date
    order_items_hash['deal']['is_nationwide'] = deal.is_nationwide
    order_items_hash['deal']['deal_type'] = deal.deal_type
    order_items_hash['deal']['is_active'] = deal.is_active
    order_items_hash['deal']['deal_image_url'] = deal.image.url


    deal_equipments = eval("#{category.camelize}DealAttribute").select("#{category}_equipments.*").joins("#{category}_equipments".to_sym).where(:deal_id => deal.id)
    #raise deal_equipments.inspect
    deal_equipments.each do |deal_equipment|
      deal_equipment_hash = {}
      deal_equipment_hash['make'] = deal_equipment.make
      deal_equipment_hash['price'] =  '%.2f' % deal_equipment.price
      deal_equipment_hash['installation'] = deal_equipment.installation
      deal_equipment_hash['activation'] = deal_equipment.activation
      deal_equipment_hash['offer'] = deal_equipment.offer
      order_items_hash['deal']['deal_equipments'] << deal_equipment_hash
    end
    order_items_array << order_items_hash
  end
  order_items_array
end

def self.search(params)
  # raise params.to_yaml
  conditions = []
  conditions << "title like '%#{params[:title]}%'" if params[:title].present?
  conditions << "deal_type = '#{params[:deal_type]}'" if params[:deal_type].present?
  conditions << "service_category_id = '#{params[:service_category_id]}'" if params[:service_category_id].present?
  conditions << "service_provider_id = '#{params[:service_provider_id]}'" if params[:service_provider_id].present?
  condition = conditions.join(' and ')
  self.where(condition)
end


private
def reject_internet(attributes)
  if attributes[:download].blank?
    if attributes[:id].present?
      attributes.merge!({:_destroy => 1}) && false
    else
      true
    end
  end
end
def reject_telephone(attributes)
  if attributes[:domestic_call_minutes].blank?
    if attributes[:id].present?
      attributes.merge!({:_destroy => 1}) && false
    else
      true
    end
  end
end
def reject_cable(attributes)
  if attributes[:free_channels].blank?
    if attributes[:id].present?
      attributes.merge!({:_destroy => 1}) && false
    else
      true
    end
  end
end
def reject_cellphone(attributes)
  if attributes[:domestic_call_minutes].blank?
    if attributes[:id].present?
      attributes.merge!({:_destroy => 1}) && false
    else
      true
    end
  end
end
def reject_bundle(attributes)
  if attributes[:download].blank? && attributes[:domestic_call_minutes].blank? && attributes[:free_channels].blank?
    if attributes[:id].present?
      attributes.merge!({:_destroy => 1}) && false
    else
      true
    end
  end
end

def reject_additional(attributes)
  if attributes[:title].blank?
    if attributes[:id].present?
      attributes.merge!({:_destroy => 1}) && false
    else
      true
    end
  end
end

def reject_include_zipcodes(attributes)
  if attributes[:deal_id].blank? || attributes[:zipcode_id].blank?
    if attributes[:id].present?
      attributes.merge!({:_destroy => 1}) && false
    else
      true
    end
  end
end

end
