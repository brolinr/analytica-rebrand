# frozen_string_literal: true

class Collections::Create < ApplicationService
  def call
    preload(:company, :lot)

    handle_errors { step :collect_lot }

    result
  end

  private

  def company
    @company ||= context[:company]
  end

  def lot
    @lot ||= context[:lot]
  end

  def collect_lot
    collection = Collection.new(lot_id: lot.reload.id, company_id: company.reload.id)
    handle_errors(collection) { assign_data(collection) if collection.save! }
  end
end
