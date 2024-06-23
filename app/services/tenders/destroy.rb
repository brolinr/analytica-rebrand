# frozen_string_literal: true

class Tenders::Destroy < ApplicationService
  def call
    preload(:tender)

    handle_errors { step :destroy_tender }

    result
  end

  private

  def tender
    @tender ||= context[:tender]
  end

  def destroy_tender
    handle_errors { assign_data(tender) if tender.reload.destroy! }
  end
end
