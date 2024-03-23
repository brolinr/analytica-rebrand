# frozen_string_literal: true

class Bids::Create < ApplicationService
  def call
    preload(:lot, :company)

    handle_errors { step(:create_bid) }

    result
  end

  private

  def company
    @company ||= context[:company] || Company.find_by(id: params[:company_id])
  end

  def lot
    @lot ||= context[:lot] || Lot.find_by(id: params[:id] || params[:lot_id])
  end

  def create_bid
    bid = company.bids.new(params)
    bid.lot_id = lot.id
    handle_errors(bid) { assign_data(bid) if bid.save! }
  end
end
