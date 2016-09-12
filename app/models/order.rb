class Order < ActiveRecord::Base
	belongs_to :app_user
	belongs_to :deal
	has_many :order_items, :dependent => :destroy
	has_many :order_addresses, :dependent => :destroy
	has_many :order_equipments, :dependent => :destroy
	validates_uniqueness_of :order_id

	has_many :user_gifts,:dependent => :destroy
	has_many :gifts, :through => :user_gifts
	before_create :update_sequences
	before_create :generate_order_number
	# validates_presence_of :deal_id, :app_user_id, :effective_price, :deal_price, :status
	SEQUENCE_TYPE = 'ORDER'##order
	TRANSACTIONAL_ORDER = 0
	NON_TRANSACTIONAL_ORDER = 1
	## ORDER WORKFLOW STATUSES
	NEW_ORDER = 'New Order'
	IN_PROGRESS = 'In Progress'
	VERIFICATION_PENDING = 'Verification Pending'
	ASSIGNED_TO_VENDOR = 'Assigned to Vendor'
	PROCESS_STARTED = 'Process Started'
	PAYMENT_PENDING = 'Payment Pending'
	SHIPMENT_DONE = 'Shipment Done'
	INSTALLATION_DONE = 'Installation Done'
	SERVICE_ACTIVATED = 'Service Activated'
	COMPLETED = 'Completed'
	CANCELLED = 'Cancelled'

	def order_place_time
		self.created_at.strftime("%d/%m/%Y %I:%M %p")
	end

	def generate_order_number
		sequence = Sequence.where(:seq_type => Order::SEQUENCE_TYPE).first
		last_transaction_number = sequence.present? ? (sequence.seq_number + 1) : 1
		deal = Deal.where(self.deal_id).first
		category = ServiceCategory.select('name').where(deal.service_category_id).first
		provider = ServiceProvider.select('name').where(deal.service_provider_id).first
		order_number = category.name[0..1].upcase + provider.name[0..1].upcase + deal.id.to_s + '#' + last_transaction_number.to_s.rjust(8,'0')
		self.order_number = order_number
		self.order_id = order_number
		self.activation_date = Time.now
		self.status = Order::NEW_ORDER
		#rand(1_00_000..10_00_000-1).to_s
	end

	private

	## sequence table is used to manage incremental order or invoice or other number by sequence type
	def update_sequences
		seq = Sequence.find_or_initialize_by(:seq_type => SEQUENCE_TYPE)
		seq_number = seq.seq_number.present? ? seq.seq_number : 0
		seq.update_attributes(:seq_number => seq_number + 1)
	end

end
