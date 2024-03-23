# frozen_string_literal: true

class Bids::Destroy < ApplicationService
  def call
    preload(:bid)

    step(:destroy_bid)

    result
  end

  private

  def bid
    @bid ||= context[:bid] || Bid.find_by(id: params[:id] || params[:bid_id])
  end

  def destroy_bid
    handle_errors { assign_data(bid) if bid.reload.destroy! }
  end
end
