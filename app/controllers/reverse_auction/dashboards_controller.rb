# frozen_string_literal: true

class ReverseAuction::DashboardsController < ReverseAuction::ApplicationController
  def index
    @auctions = my_auctions.merge(collaborated_auctions)
    @collaboration_requests = current_company.collaborations.pending_requests
  end

  private

  def collaborated_auctions
    @collaborated_auctions ||= Auction.collaborated(current_company.id)
  end

  def my_auctions
    @my_auctions ||= Auction.where(company_id: current_company.id)
  end
end
