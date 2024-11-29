class Receipt
  include Cacheable
  include Pointable

  attr_accessor :uuid, :receipt_information
  alias_method :pointable_information, :receipt_information

  def initialize(uuid, receipt_information)
    @uuid = uuid
    @receipt_information = receipt_information
  end

  def self.create(receipt_information)
    receipt = Receipt.new(nil, receipt_information)
    receipt.uuid = receipt.create(receipt_information.to_json)
    receipt
  end

  def self.get_points(uuid)
    receipt = Receipt.new(uuid, nil)
    if receipt.find(uuid)
      receipt.receipt_information = JSON.parse(receipt.find(uuid), symbolize_names: true)
    else
      raise ReceiptNotFoundError, "ReceiptNotFoundError: Could not find a receipt with the uuid: #{uuid}"
    end
    receipt.total_points
  end
end

class ReceiptNotFoundError < StandardError
end