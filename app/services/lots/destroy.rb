# frozen_string_literal: true

class Lots::Destroy < ApplicationService
  def call
    preload(:lot)

    step(:destroy_lot)

    result
  end

  private

  def lot
    @lot ||= context[:lot] || Lot.find_by(id: params[:lot_id] || params[:id])
  end

  def destroy_lot
    handle_errors { assign_data(lot) if lot.reload.destroy! }
  end
end
