class TenderBoard::TendersController < TenderBoard::ApplicationController
  before_action :tender, only: :show

  def index
    @pagy, @tenders = pagy(Tender.all.ransack(params[:q]).result(distinct: true), items: 20)
  end

  def show
    @tags = tender.tags
  end

  def collected; end

  private

  def tender
    @tender ||= Tender.find(params[:id])
  end
end
