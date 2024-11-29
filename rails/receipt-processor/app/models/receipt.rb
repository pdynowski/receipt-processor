class Receipt
  include Cacheable
  include Scorable

  def initialize(receipt_information)
    @receipt_information = receipt_information
  end

  def self.create(receipt_information)
    receipt = Receipt.new(receipt_information)
    receipt.create(receipt_information.to_json)
  end
end