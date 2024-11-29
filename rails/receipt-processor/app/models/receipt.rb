class Receipt
  include Cacheable
  include Scorable

  attr_accessor :uuid, :receipt_information

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

  end
end