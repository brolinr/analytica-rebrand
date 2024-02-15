# frozen_string_literal: true

class CompanyOnboardings::Create < ApplicationService
  def call
    step :create_onboarding
    result
  end

  private

  def create_onboarding
    @company_onboarding = CompanyOnboarding.new(params)

    if @company_onboarding.save
      assign_data(@company_onboarding)
    else
      handle_validation_errors(@company_onboarding)
    end
  end
end
