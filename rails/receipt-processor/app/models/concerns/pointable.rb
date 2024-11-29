module Pointable

  QUARTER_TOTAL_POINTS = 25
  DOLLAR_TOTAL_POINTS = 50
  POINTS_PER_PAIR_OF_ITEMS = 5
  DESCRIPTION_LENGTH_FACTOR_FOR_ITEM = 3
  PRICE_FACTOR_FOR_ITEM = 0.2
  POINTS_FOR_ODD_PURCHASE_DATE = 6
  EARLIEST_PURCHASE_HOUR = 14
  LATEST_PURCHASE_HOUR = 16
  POINTS_FOR_PURCHASE_TIME = 10

  def total_points
    pointable_information.reduce(0) do |points, (k, v)|
      points + send("points_for_#{k}", v)
    end
  end

  # points_for_retailer accepts string value for retailer
  # name, strips all non-alphanumeric characters (anything
  # that isn't a letter or number) and returns the length
  # of the remaining string as an integer representing
  # the number of points earned from the retailer name

  def points_for_retailer(value)
    value.gsub(/[^a-zA-Z0-9]/, '').length
  end

  def points_for_items(value)
    points_for_item_qty(value) + points_for_items_by_descriptions(value)
  end

  # points_for_total accepts a string value for the total
  # value of the receipt. It returns an integer value for
  # points earned based on the value string after the
  # decimal

  def points_for_total(value)
    cents = value.split('.')[1]
    case cents
    when '00'
      DOLLAR_TOTAL_POINTS + QUARTER_TOTAL_POINTS
    when '25', '50', '75'
      QUARTER_TOTAL_POINTS
    else 0
    end
  end

  # points_for_purchaseDate accepts a string representing
  # the date of the purchase. It checks the value of the day
  # of the date, and returns an integer value representing 
  # the appropriate number of points earned

  def points_for_purchaseDate(value)
    value.split('-')[2].to_i.odd? ? POINTS_FOR_ODD_PURCHASE_DATE : 0
  end

  # points_for_purchaseTime accepts a string representing the
  # time of purchase formatted in 24-hour time. It checks if 
  # the time of purchase is during the award hours, and returns
  # an integer representing the points earned

  def points_for_purchaseTime(value)
    (EARLIEST_PURCHASE_HOUR...LATEST_PURCHASE_HOUR).include?(value.split(':')[0].to_i) ? POINTS_FOR_PURCHASE_TIME : 0
  end

  # points_for_item_qty accepts an array containing
  # purchased items. It returns an integer value 
  # representing the points earned for each complete
  # pair of items purchased
  def points_for_item_qty(items)
    POINTS_PER_PAIR_OF_ITEMS * (items.length / 2)
  end

  # points_for_items_by_descriptions accepts an array
  # containing purchased items. it sums over the array
  # of items and returns an integer representing the 
  # total points earned for item purchases based on
  # the item descriptions

  def points_for_items_by_descriptions(items)
    items.reduce(0) do |points, item|
      points + points_for_item_by_description(item)
    end
  end

  # points_for_item_by_description accepts a hash
  # representing a single purchased item. It then
  # checks the stripped length of the item description
  # to determine whether to award points for the price
  # of the item. It returns an integer representing the
  # points earned for the single item.

  def points_for_item_by_description(item)
    if item[:shortDescription].strip.length % DESCRIPTION_LENGTH_FACTOR_FOR_ITEM == 0
      price = item[:price].to_f
      points = price * PRICE_FACTOR_FOR_ITEM
      points.ceil
    else
      0
    end
  end

end