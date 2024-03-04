# frozen_string_literal: true

class AuctionRegistrations::Create < ApplicationService
  def call
    preload(:company, :auction)

    step(:create_registration)

    result
  end

  private

  def company
    @company ||= context[:company] || params[:company_id]
  end

  def auction
    @auction ||= context[:auction] || params[:id]
  end

  def create_registration
    return add_error('Accept the terms first') unless params[:terms] == '1' || params[:terms] == true

    registration = AuctionRegistration.new(params)
    registration.auction_id = auction&.id
    registration.company_id = company&.id
    handle_errors(registration) { assign_data(registration) if registration.save! }
  end
end
