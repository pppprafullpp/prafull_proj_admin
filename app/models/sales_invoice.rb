class SalesInvoice < ActiveRecord::Base
  before_create :update_sequences

  ## CONSTANTS ##
  SEQUENCE_TYPE = 'LI'



  def self.create_invoice(provider_id, provider_type, order_id, item_qty, net_amount)
    invoice = self.where(:provider_id => provider_id.to_i,:provider_type => provider_type, :order_id => order_id).first_or_initialize

    invoice.invoice_number = "#{SalesInvoice::SEQUENCE_TYPE}#{order_id}" + generate_invoice_number.to_s.rjust(8,'0')
    invoice.invoice_date = Time.now
    invoice.item_qty = item_qty
    invoice.net_amount = net_amount

    if invoice.new_record?
      invoice.save
    else
      invoice.touch
    end
  end

  private
  def update_sequences
    seq = Sequence.find_or_initialize_by(:seq_type => SEQUENCE_TYPE)
    seq_number = seq.seq_number.present? ? seq.seq_number : 0
    seq.update_attributes(:seq_number => seq_number + 1)
  end

  def self.generate_invoice_number
    sequence = Sequence.where(:seq_type => LabOrder::SEQUENCE_TYPE).first
    last_transaction_number = sequence.present? ? (sequence.seq_number + 1) : 1
    last_transaction_number
  end
end