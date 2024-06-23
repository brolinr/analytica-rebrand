# frozen_string_literal: true

class ReverseAuction::BidsController < ReverseAuction::ApplicationController
  before_action :bid, except: :create
  before_action :lot, except: :destroy

  def new
    unless current_company.auction_registrations.exists?(auction_id: lot.auction.id)
      redirect_to(reverse_auction_live_auctions_path, notice: I18n.t('controllers.bids.register_first'))
    end
    @bid = Bid.new
  end

  def create
    result = Bids::Create.call(context: { company: current_company, lot: lot }, params: permitted_params)

    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_auction_lot_path(lot.auction, lot),
      failure_path: request.referer || reverse_auction_auction_lot_path(lot.auction, lot),
      success_string_key: 'controllers.bids.submitted'
    )
  end

  def show; end

  def index
    @q = Lot.where(id: current_company.bids.pluck(:lot_id)).ransack(params[:q])
    @pagy, @lots = pagy(@q.result, items: 30)
  end

  def destroy
    result = Bids::Destroy.call(context: { bid: bid })

    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_auction_lot_path(lot.auction, lot),
      failure_path: request.referer || reverse_auction_auction_lot_path(lot.auction, lot),
      success_string_key: 'controllers.bids.retracted'
    )
  end

  private

  def permitted_params
    params.require(:bid).permit(:amount, images: [])
  end

  def bid
    @bid ||= Bid.find_by(id: params[:id])
  end

  def lot
    @lot ||= Lot.find_by(id: params[:lot_id])
  end
end
