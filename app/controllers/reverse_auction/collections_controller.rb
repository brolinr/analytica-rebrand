# frozen_string_literal: true

class ReverseAuction::CollectionsController < ReverseAuction::ApplicationController
  before_action :collection, only: :destroy
  def index
    @q = Lot.where(id: current_company.collections.pluck(:lot_id)).ransack(params[:q])
    @pagy, @collected_lots = pagy(@q.result, items: 30)
  end

  def create
    result = Collections::Create.call(context: { company: current_company, collectable: collectable })

    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_collections_path,
      failure_path: request.referer || reverse_auction_collections_path,
      success_string_key: 'controllers.collections.added'
    )
  end

  def destroy
    result = Collections::Destroy.call(context: { collection: collection })

    error_or_redirect(
      object: result,
      success_path: request.referer || reverse_auction_collections_path,
      failure_path: request.referer || reverse_auction_collections_path,
      success_string_key: 'controllers.collections.removed'
    )
  end

  private

  def permitted_params
    params.require(:collection).permit(:collectable_id, :collectable_type)
  end

  def collectable
    @collectable ||= permitted_params[:collectable_type].constantize.send(:find_by, { id: permitted_params[:collectable_id] })
  end

  def collection
    @collection = Collection.find_by(id: params[:id])
  end
end
