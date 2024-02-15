# frozen_string_literal: true

class Companies::Create < ApplicationService
  def call
    preload(:company_onboarding, :company)

    transaction { step(:create_company) }

    result
  end

  private

  def company_onboarding
    @company_onboarding ||= context[:company_onboarding]
  end

  def company
    @company ||= Company.new(
      name: company_onboarding.name,
      email: company_onboarding.email,
      phone: company_onboarding.phone,
      address: company_onboarding.address,
      city: company_onboarding.city,
      terms: company_onboarding.terms,
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
  end

  def create_company
    unless company_onboarding.approved? && !Company.exists?(email: company_onboarding.email)
      return add_error(I18n.t('errors.onboarding_not_approved'))
    end

    if company.save
      update_onboarding_tokens
      assign_data(company)
    else
      handle_validation_errors(company)
    end
  end

  def update_onboarding_tokens
    company_onboarding.tokens.where(status: 'active', purpose: 'onboarding_approval').update_all(status: 'void')
  end
end
