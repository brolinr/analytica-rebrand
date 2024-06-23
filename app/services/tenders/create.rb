# frozen_string_literal: true

class Tenders::Create < ApplicationService
  def call
    preload(:administrator)

    handle_errors { step :create_tender }

    result
  end

  private

  def administrator
    @administrator ||= context[:administrator]
  end

  def create_tender
    tender = administrator.tenders.build(params)
    handle_errors(tender) { assign_data(tender) if tender.save! }
  end
end
