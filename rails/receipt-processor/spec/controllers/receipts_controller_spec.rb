require 'rails_helper'

RSpec.describe ReceiptsController, type: :controller do

  describe 'POST #process' do

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

    it 'endpoint exists' do
      expect{ post :process_receipt, params: { receipt: receipt_info } }.not_to raise_error
    end

    describe 'with valid data' do

      it 'it returns an id that can be used to retrieve the receipt' do
        post :process_receipt, params: { receipt: receipt_info }
        expect(JSON.parse(response.body).keys).to eq ['id']
      end

      it 'stores a receipt' do
        post :process_receipt, params: { receipt: receipt_info }
        uuid = JSON.parse(response.body)['id']
        expect(REDIS.get(uuid)).to eq receipt_info.to_json
      end

    end

    describe 'with no data' do
      it 'rasies a ParameterMissing error' do
        expect{ post :process_receipt, params: { } }.to raise_error(ActionController::ParameterMissing)
      end
    end
  end

  describe 'GET #:id/points' do

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

    it 'endpoint exists' do
      expect{ get :points, params: {id: '12345678-1234-1234-1234-123456789012'} }.not_to raise_error
    end

    it 'returns the correct points value when given a valid uuid' do
      receipt = Receipt.create(receipt_info)
      get :points, params: { id: receipt.uuid }
      expect(JSON.parse(response.body)).to eq({ 'points' => 28 })
    end

    it 'returns an error message when given an invalid uuid' do
      get :points, params: { id: '12345678-1234-1234-1234-123456789012' }
      expect(response.status).to eq 404
      expect(JSON.parse(response.body)).to eq({ 'error' => 'ReceiptNotFoundError: Could not find a receipt with the uuid: 12345678-1234-1234-1234-123456789012' })
    end
  end
end