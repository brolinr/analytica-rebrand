# frozen_string_literal: true

class ReverseAuction::AuctionRegistrationsController < ReverseAuction::ApplicationController
  before_action :auction
  before_action :registered?

  def new
    @auction_registration = current_company.auction_registrations.new
  end

  def create
    result = AuctionRegistrations::Create.call(params: permitted_params,
                                               context: {
                                                 auction: auction, company: current_company
                                               })
    to = result.data.is_a?(AuctionRegistration) ? reverse_auction_auction_path(auction) : reverse_auction_auctions_path

    error_or_redirect(
      object: result,
      success_path: to,
      failure_path: reverse_auction_live_auctions_path,
      success_string_key: 'flash.created'
    )
  end

  def update
    result = AuctionRegistrations::Update.call(params: permitted_params,
                                               context: { auction_registration: auction_registration })
    to = if result.data.is_a?(AuctionRegistration)
           reverse_auction_auction_path(auction)
         else
           reverse_auction_live_auctions_path
         end

    error_or_redirect(
      object: result,
      success_path: to,
      failure_path: reverse_auction_live_auctions_path,
      success_string_key: 'flash.update'
    )
  end

  private

  def permitted_params
    params.require(:auction_registration).permit(:approval, :delivery_city, :delivery_address, :delivery_phone, :terms)
  end

  def auction
    @auction ||= Auction.find_by(id: params[:auction_id])
  end

  def auction_registration
    @auction_registration ||= AuctionRegistration.find_by(id: params[:id])
  end

  def registered?
    redirect_to reverse_auction_live_auctions_path if AuctionRegistration.exists?(company_id: current_company.id)
  end
end
