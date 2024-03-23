# frozen_string_literal: true

class Lots::Update < ApplicationService
  def call
    preload(:lot)

    step(:update_lot)

    result
  end

  private

  def lot
    @lot ||= context[:lot] || Lot.find_by(params[:lot_id] || params[:id])
  end

  def update_lot
    handle_errors { assign_data(lot) if lot.update!(params) }
  end
end
