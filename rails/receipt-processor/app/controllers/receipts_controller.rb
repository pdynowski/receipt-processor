class ReceiptsController < ApplicationController

  before_action :permitted_params, only: :process_receipt

  # Normally would just call this process, as that's the name of the endpoint,
  # but "process" is already a method on the base controller, so needed to use
  # a different name for the method
  def process_receipt
    receipt_uuid = Receipt.create(permitted_params.to_h)
    render :json => { id: receipt_uuid }
  end


  private

  # Requires that a receipt exists, and defines parameters that will be permitted
  # We could require other parameters here, as they are required for scoring, but for now,
  # missing receipt parameters will not invalidate the receipt as a whole
  def permitted_params
    params.permit(receipt: [:retailer, :purchaseDate, :purchaseTime, :total, { items: [:shortDescription, :price] }]).require(:receipt)
  end
end