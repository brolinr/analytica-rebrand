# frozen_string_literal: true

class Collections::Create < ApplicationService
  def call
    preload(:company, :collectable)

    handle_errors { step :collect_collectable }

    result
  end

  private

  def company
    @company ||= context[:company]
  end

  def collectable
    @collectable ||= context[:collectable]
  end

  def collect_collectable
    collection = collectable.collections.build(company_id: company.reload.id)
    handle_errors(collection) { assign_data(collection) if collection.save! }
  end
end
