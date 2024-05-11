# frozen_string_literal: true

class ReverseAuction::AuctionsController < ReverseAuction::ApplicationController
  def new
    @auction = Auction.new
    @collaborators = Company.where.not(id: current_company.id).where(supplier: true)
  end

  def create
    result = Auctions::Create.call(context: { company: current_company }, params: permitted_params)

    error_or_redirect(
      object: result,
      success_path: new_reverse_auction_auction_lot_path(result&.data) || reverse_auction_dashboards_path,
      failure_path: request.referer || reverse_auction_dashboards_path,
      success_string_key: 'flash.created'
    )
  end

  def show
    @auction = Auction.find(params[:id])
    @q = @auction.lots.order(:created_at).ransack(params[:q])
    @pagy, @lots = pagy(@q.result, items: 30)
  end

  def index
    collaborated_ids = Auction.collaborated(current_company.id).pluck(:id)
    company_auctions = Auction.where(company_id: current_company.id).pluck(:id)
  
    combined_ids = (collaborated_ids + company_auctions).uniq
  
    @q = Auction.where(id: combined_ids).ransack(params[:q])
    @pagy, @auctions = pagy(@q.result(distinct: true), items: 20)
  end
  

  def live
    unless current_company.bidder
      redirect_to reverse_auction_dashboards_path, notice: I18n.t('controllers.auctions.upgrade_sub')
    end
    @auctions = Auction.live
    @pagy, @auctions = pagy(@auctions, items: 10)
  end

  def edit
    @collaborators = Company.where.not(id: auction.company_id).where(supplier: true)
  end

  def update
    result = Auctions::Update.call(context: { auction: auction }, params: permitted_params)

    error_or_redirect(
      object: result,
      success_path: new_reverse_auction_auction_lot_path(result&.data) || reverse_auction_dashboards_path,
      failure_path: reverse_auction_dashboards_path,
      success_string_key: 'flash.updated'
    )
  end

  def destroy
    result = Auctions::Destroy.call(context: { auction: auction })

    error_or_redirect(
      object: result,
      success_path: reverse_auction_auctions_path,
      failure_path: reverse_auction_auctions_path,
      success_string_key: 'flash.destroyed'
    )
  end

  private

  def permitted_params
    params.require(:auction).permit(:title, :description, :starts_at, :closes_at, :image, collaborator_ids: [])
  end

  def auction
    @auction ||= current_company.auctions.find(params[:id])
  rescue ActiveRecord::RecordNotFound => e
    redirect_to reverse_auction_dashboards_path, notice: e
  end
end
