class ServiceProvider < ActiveRecord::Base
  belongs_to :service_category
  has_many :deals, :dependent => :destroy
  has_many :service_provider_checklists, :dependent => :destroy
  has_many :channel_packages

  # mount_uploader :logo, ImageUploader
  validates_presence_of :service_category_id, :name

  def as_json(opts={})
    json = super(opts)
    Hash[*json.map{|k, v| [k, v || ""]}.flatten]
  end

  def provider_logo_url
    logo.url
  end

  def self.get_provider_by_category(service_category_id)
    (service_category_id.present?) ? self.select('id,name').where(:service_category_id => service_category_id) : []
  end

  def self.import(file)
    CSV.foreach(file.path, :headers => true) do |row|
      #service_provider_hash = row.to_hash # exclude the price field
      service_provider_hash = { :id => row['ID'], :service_category_id => row['ServiceCategory ID'], :name => row['Name'], :address => row['Address'], :state => row['State'], :city => row['City'], :zip => row['Zip'], :email => row['Email'], :telephone => row['Telephone'], :is_active => row['Is Active'], :is_preferred => row['Is Preferred'],
                                :created_at => row['Created At'], :updated_at => row['Updated At'], :logo => row['Logo'] }
      service_provider = ServiceProvider.where(:id => service_provider_hash[:id])
      if service_provider.count == 1
        service_provider.first.update_attributes(service_provider_hash.except("logo"))
      else
        ServiceProvider.create!(service_provider_hash.except("logo"))
      end # end if !service_category.nil?
    end # end CSV.foreach
  end # end self.import(file)

  def self.get_deal_wise_provider_ids(category_deals_array_hash)
    providers = []
    category_deals_array_hash.each do |deal|
      providers << deal["service_provider_id"]
    end
    providers.uniq
  end
  #def self.import(file)
  #	spreadsheet = open_spreadsheet(file)
  #  header = spreadsheet.row(1)
  #  (2..spreadsheet.last_row).each do |i|
  #  	row = Hash[[header, spreadsheet.row(i)].transpose]
  #  	service_category = find_by_name(row["name"]) || new
  #    if row["name"].present?
  #      service_category.name = row["name"]
  #    end
  #    if row["description"].present?
  #      service_category.description = row["description"]
  #    end
  #  	#product.attributes = row.to_hash.slice(*accessible_attributes)
  #  	service_category.save!
  #	end
  #end	

  #def self.open_spreadsheet(file)
  #	case File.extname(file.original_filename)
  #	when ".csv" then Roo::CSV.new(file.path, {})
  #	when ".xls" then Roo::Excel.new(file.path, {})
  #	when ".xlsx" then Roo::Excelx.new(file.path, {})
  #	else raise "Unknown file type: #{file.original_filename}"
  #	end
  #end

end
