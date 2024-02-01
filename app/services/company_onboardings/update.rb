# frozen_string_literal: true

class CompanyOnboardings::Update < ApplicationService
  def call
    preload(:company_onboarding)

    step :update_onboarding

    result
  end

  private

  def company_onboarding
    @company_onboarding ||= context[:company_onboarding] || CompanyOnboarding.find(params[:id])
  end

  def update_onboarding
    add_error(I18n.t('flash.not_found', model: 'COmpany onboarding')) if company_onboarding.is_a?(CompanyOnboarding)

    if company_onboarding.update(params)
      assign_data(company_onboarding)
      company_onboarding.tokens.where(status: 0, purpose: 1).each(&:void!)
    else
      add_error(company_onboarding.errors.full_messages)
    end
  end
end
