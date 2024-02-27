class ReverseAuction::AuctionsController < ReverseAuction::ApplicationController
  before_action :auction, except: %i[create new index live show]
  def new
    @auction = Auction.new
    @collaborators = Company.where.not(id: current_company.id).where(supplier: true)
  end

  def create
    result = Auctions::Create.call(context: { company: current_company }, params: permitted_params)

    error_or_redirect(
      object: result,
      success_path: result.data.is_a?(Auction) && result.data.valid? ? edit_reverse_auction_auction_path(result&.data) : reverse_auction_dashboards_path,
      failure_path: request.referer || reverse_auction_dashboards_path,
      success_string_key: 'flash.created'
    )
  end

  def show
    #ADD check to see if current company is creator or collaborator
    @auction = Auction.find(params[:id])
  end

  def index
    redirect_to reverse_auction_dashboards_path, notice: 'You are not approved to have auctions. Upgrade your subscription! ' unless current_company.supplier

    company_auctions = current_company.auctions.select('auctions.*')
    collaborating_auctions = Auction.joins(:collaborators).where(collaborators: { company_id: current_company.id, acceptance_status: :accepted }).select('auctions.*')
    combined_auctions = Auction.from("(#{company_auctions.to_sql} UNION #{collaborating_auctions.to_sql}) AS auctions")

    @q = combined_auctions.ransack(params[:q])
    @pagy, @auctions = pagy(@q.result(distinct: true), items: 20)
  end

  def live
    redirect_to reverse_auction_dashboards_path, notice: 'You are not approved to bid. Upgrade your subscription! ' unless current_company.bidder
    @auctions = Auction.where("starts_at <= ? AND closes_at >= ?", Time.current, Time.current)
    @pagy, @auctions = pagy(@auctions, items: 10)
  end

  def edit
    @collaborators = Company.where.not(id: auction.company_id).where(supplier: true)
  end

  def update
    result = Auctions::Update.call(context: { auction: auction }, params: permitted_params)

    error_or_redirect(
      object: result,
      success_path: result.data.is_a?(Auction) ? edit_reverse_auction_auction_path(result&.data) : reverse_auction_dashboards_path,
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
  end
end