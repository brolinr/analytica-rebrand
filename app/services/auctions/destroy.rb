class Auctions::Destroy < ApplicationService
  def call
    preload(:auction)

    step(:destroy_auction)

    result
  end

  private
  def auction
    @auction ||= context[:auction] || Auction.find(params[:id])
  end

  def destroy_auction
    return assign_data(auction) if auction.destroy

    handle_validation_errors(auction)
  end
end