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


  describe '.get_points' do

    let(:receipt_info)  {
                          {
                            "retailer": "Target",
                            "purchaseDate": "2022-01-01",
                            "purchaseTime": "13:01",
                            "items": [
                              {
                                "shortDescription": "Mountain Dew 12PK",
                                "price": "6.49"
                              },{
                                "shortDescription": "Emils Cheese Pizza",
                                "price": "12.25"
                              },{
                                "shortDescription": "Knorr Creamy Chicken",
                                "price": "1.26"
                              },{
                                "shortDescription": "Doritos Nacho Cheese",
                                "price": "3.35"
                              },{
                                "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
                                "price": "12.00"
                              }
                            ],
                            "total": "35.35"
                          }
                         }

    let(:bad_uuid) { '43a1d83f-9df9-49e6-bb23-cab35be4786e' }

    it 'returns the correct number of points for a receipt given a valid uuid' do
      receipt = Receipt.create(receipt_info)
      expect(Receipt.get_points(receipt.uuid)).to eq 28
    end

    it 'returns an error given an invalid uuid' do
      expect{ Receipt.get_points(bad_uuid) }.to raise_error(ReceiptNotFoundError)
    end
  end
end