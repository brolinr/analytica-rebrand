# frozen_string_literal: true

class CompanyOnboardings::Update < ApplicationService
  def call
    preload(:company_onboarding)

    step(:update_onboarding)
    step(:expire_tokens)

    result
  end

  private

  def company_onboarding
    @company_onboarding ||= context[:company_onboarding].reload || CompanyOnboarding.find(params[:id])
  end

  def update_onboarding
    unless company_onboarding.is_a?(CompanyOnboarding)
      return add_error(I18n.t('flash.not_found', model: 'Company onboarding'))
    end

    if company_onboarding.update(params)
      company_onboarding.pending_review!
      assign_data(company_onboarding)
    else
      handle_validation_errors(company_onboarding)
    end
  end

  def expire_tokens
    company_onboarding.tokens.where(status: 0, purpose: 1).update_all(status: 'void')
  end
end
