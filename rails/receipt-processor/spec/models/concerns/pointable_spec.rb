require 'rails_helper'

class PointableClass
  include Pointable

  def pointable_information
  end
end 

RSpec.describe Pointable do

  it 'loads correctly' do
    expect(Pointable).to be_a Module
  end

  let(:pointable_information_1) {
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

  let(:pointable_information_2) {
                                  {
                                    "retailer": "M&M Corner Market",
                                    "purchaseDate": "2022-03-20",
                                    "purchaseTime": "14:33",
                                    "items": [
                                      {
                                        "shortDescription": "Gatorade",
                                        "price": "2.25"
                                      },{
                                        "shortDescription": "Gatorade",
                                        "price": "2.25"
                                      },{
                                        "shortDescription": "Gatorade",
                                        "price": "2.25"
                                      },{
                                        "shortDescription": "Gatorade",
                                        "price": "2.25"
                                      }
                                    ],
                                    "total": "9.00"
                                  }
                                }
  
  let(:pointable) { PointableClass.new }

  describe '#total_points' do
    it 'returns the correct total points value for pointable_information_1' do
      allow(pointable).to receive(:pointable_information).and_return(pointable_information_1)
      expect(pointable.total_points).to eq 28
    end

    it 'returns the correct total points value for pointable_information_2' do
      allow(pointable).to receive(:pointable_information).and_return(pointable_information_2)
      expect(pointable.total_points).to eq 109
    end
  end

  describe '#points_for_retailer' do
    it 'returns the correct points given a retailer name' do
      expect(pointable.points_for_retailer('Target')).to eq 6
      expect(pointable.points_for_retailer('M&M Corner Market')).to eq 14
    end
  end

  describe '#points_for_total' do
    it 'returns 0 points if the total is not a multiple of 0.25' do
      expect(pointable.points_for_total('6.49')).to eq 0
    end

    it 'returns 25 points if the total is a multiple of 0.25' do
      expect(pointable.points_for_total('6.50')).to eq 25
    end

    # note that this is 75 because, if the dollar amount is round, the 25 points for the 
    # mulitple of 0.25 will also be added to the 50 expected for the round dollar amount
    it 'returns 75 points if the total is a round dollar amount' do
      expect(pointable.points_for_total('6.00')).to eq 75
    end
  end

  describe '#points_for_item_qty' do
    it 'returns correct points value based on number of items' do
      expect(pointable.points_for_item_qty([{}, {}, {}, {}, {}])).to eq 10
      expect(pointable.points_for_item_qty([{}, {}, {}, {}])).to eq 10
      expect(pointable.points_for_item_qty([{}])).to eq 0
    end
  end

  describe '#points_for_items_by_description' do
    let(:items) { 
                  [
                    {
                      "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
                      "price": "12.00"
                    },
                    {
                      "shortDescription": "Emils Cheese Pizza",
                      "price": "12.25"
                    },
                    {
                      "shortDescription": "Gatorade",
                      "price": "2.25"
                    }
                  ]
                }

    it 'returns correct points value based on description of items' do
      expect(pointable.points_for_items_by_descriptions(items)).to eq 6
    end
  end

  describe '#points_for_item_by_description' do
    let(:scored_item_1)     { 
                              {
                                "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
                                "price": "12.00"
                              }
                            }
    let(:scored_item_2)     { 
                              {
                                "shortDescription": "Emils Cheese Pizza",
                                "price": "12.25"
                              }
                            } 
    let(:non_scoring_item)  {
                              {
                                "shortDescription": "Gatorade",
                                "price": "2.25"
                              }
                            }           

    it 'returns no points if the trimmed item description length is not a multiple of 3' do
      expect(pointable.points_for_item_by_description(non_scoring_item)).to eq 0
    end

    it 'returns the correct number of points if the trimmed item description length is a multiple of 3' do
      expect(pointable.points_for_item_by_description(scored_item_1)).to eq 3
      expect(pointable.points_for_item_by_description(scored_item_2)).to eq 3
    end
  end

  describe '#points_for_items' do
    let(:items) { 
                  [
                    {
                      "shortDescription": "   Klarbrunn 12-PK 12 FL OZ  ",
                      "price": "12.00"
                    },
                    {
                      "shortDescription": "Emils Cheese Pizza",
                      "price": "12.25"
                    },
                    {
                      "shortDescription": "Gatorade",
                      "price": "2.25"
                    }
                  ]
                }

    it 'returns correct points value based on description of items' do
      expect(pointable.points_for_items(items)).to eq 11
    end
  end

  describe '#points_for_purchaseDate' do
    it 'returns correct points if the purchase day is odd' do
      expect(pointable.points_for_purchaseDate('2024-11-29')).to eq 6
    end

    it 'returns 0 points if purchase day is even' do
      expect(pointable.points_for_purchaseDate('2024-11-28')).to eq 0
    end
  end

  describe '#points_for_purchaseTime' do
    it 'returns correct points if time of purchase is between 2 and 4 PM' do
      expect(pointable.points_for_purchaseTime('14:01')).to eq 10
      expect(pointable.points_for_purchaseTime('15:33')).to eq 10
    end

    it 'returns 0 points if purchase time is not between 2 and 4 PM' do
      expect(pointable.points_for_purchaseTime('13:59')).to eq 0
      expect(pointable.points_for_purchaseTime('16:01')).to eq 0
    end
  end

end