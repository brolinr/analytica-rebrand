class ReverseAuction::AuctionsController < ReverseAuction::ApplicationController
  before_action :auction, except: %i[create new index]
  def new
    @auction = Auction.new
    @collaborators = Company.where.not(id: "7612b368-254a-4b3a-8ffa-d6455ebc98c8").where(supplier: true)
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

  def show; end

  def index
    @auctions = current_company.auctions.order(:starts_at)
  end

  def edit; end

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
    params.require(:auction).permit(:title, :description, :starts_at, :closes_at, collaborator_ids: [])
  end

  def auction
    @auction ||= current_company.auctions.find(params[:id])
  end
end