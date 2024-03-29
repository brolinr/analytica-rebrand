# frozen_string_literal: true

class Companies::Update < ApplicationService
  def call
    preload(:company)

    step(:update_company)

    result
  end

  private

  def company
    @company ||= context[:company]
  end

  def update_company
    handle_errors { assign_data(company) if company.update!(params) }
  end
end
