require 'rails_helper'

RSpec.describe Receipt do

  describe '.create' do
    let(:receipt_info) { 
                        {
                          "retailer": "Walgreens",
                          "purchaseDate": "2022-01-02",
                          "purchaseTime": "08:13",
                          "total": "2.65",
                          "items": [
                              {"shortDescription": "Pepsi - 12-oz", "price": "1.25"},
                              {"shortDescription": "Dasani", "price": "1.40"}
                          ]
                        }
                      }

    let(:uuid)        { "43a1d83f-9df9-49e6-bb23-cab35be4786f" }
    let(:receipt)     { Receipt.new(nil, receipt_info) }

    it 'returns a uuid for the stored receipt' do
      expect(Receipt.create(receipt_info).uuid).to match /^[A-Fa-f0-9]{8}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{4}-[A-Fa-f0-9]{12}$/
    end

    it 'stores the receipt information' do
      allow(Receipt).to receive(:new).and_return(receipt)
      allow(receipt).to receive(:generate_uuid).and_return(uuid)
      Receipt.create(receipt_info)
      expect(REDIS.get(uuid)).to eq receipt_info.to_json
    end
  end
end