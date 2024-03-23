# frozen_string_literal: true

class Collections::Destroy < ApplicationService
  def call
    preload(:collection)

    step :destroy_collection

    result
  end

  private

  def collection
    @collection ||= context[:collection]
  end

  def destroy_collection
    handle_errors { assign_data(collection) if collection.reload.destroy! }
  end
end
