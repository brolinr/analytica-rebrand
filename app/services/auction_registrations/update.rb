# frozen_string_literal: true

class AuctionRegistrations::Update < ApplicationService
  def call
    preload(:auction_registration)

    step(:update_registration)

    result
  end

  def auction_registration
    @auction_registration ||= context[:auction_registration] || AuctionRegistration.find_by(id: params[:id])
  end

  def update_registration
    handle_errors { assign_data(auction_registration) if auction_registration.update!(approval: params[:approval]) }
  end
end
