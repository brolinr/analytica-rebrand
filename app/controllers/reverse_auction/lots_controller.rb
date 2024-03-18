# frozen_string_literal: true

class ReverseAuction::LotsController < ReverseAuction::ApplicationController
  before_action :either_collaborator_or_auctioneer, except: :show
  before_action :manipulate_your_own_lot, except: %i[new create show]
  before_action :lot, only: %i[show destroy]

  def new
    @lot = auction.lots.build
    @q = auction.lots.order(:created_at).ransack(params[:q])
    @pagy, @lots = pagy(@q.result)
  end

  def create
    result = Lots::Create.call(context: { auction: auction, company: current_company }, params: permitted_params)
    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_dashboards_path,
      failure_path: request.referer || reverse_auction_dashboards_path,
      success_string_key: 'flash.created'
    )
  end

  def show; end

  def update
    result = Lots::Update.call(context: { lot: lot }, params: permitted_params)

    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_dashboards_path,
      failure_path: request.referer || reverse_auction_dashboards_path,
      success_string_key: 'flash.updated'
    )
  end

  def destroy
    result = Lots::Destroy.call(context: { lot: lot })

    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_dashboards_path,
      failure_path: request.referer || reverse_auction_dashboards_path,
      success_string_key: 'flash.updated'
    )
  end

  private

  def permitted_params
    params.require(:lot).permit(:title, :description, :asking_price, :image)
  end

  def lot
    @lot ||= Lot.find(params[:id])
  end

  def auction
    @auction ||= Auction.find(params[:auction_id])
  end

  def either_collaborator_or_auctioneer
    collaborators = auction.collaborators.pluck(:collaborator_id)
    return if collaborators.include?(current_company.id) || auction.company_id == current_company.id

    redirect_to reverse_auction_dashboards_path, flash: { alert: I18n.t('models.common.not_authorized') }
  end

  def manipulate_your_own_lot
    return if lot.collaborator_id == current_company.id

    redirect_to reverse_auction_dashboards_path, flash: { alert: I18n.t('models.common.not_authorized') }
  end
end
