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
end