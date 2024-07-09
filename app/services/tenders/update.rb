# frozen_string_literal: true

class Tenders::Update < ApplicationService
  def call
    preload(:tender)

    handle_errors { step :update_tender }

    result
  end

  private

  def tender
    @tender ||= context[:tender]
  end

  def update_tender
    handle_errors { assign_data(tender) if tender.update!(params) }
  end
end
