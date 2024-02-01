# frozen_string_literal: true

class CompanyOnboardings::Approve < ApplicationService
  def call
    preload(:company_onboarding)

    step :approve_onboarding

    result
  end

  private

  def company_onboarding
    @company_onboarding ||= context[:company_onboarding] || CompanyOnboarding.find(params[:id])
  end

  def onboarding_tokens
    if company_onboarding.is_a?(CompanyOnboarding)
      @onboarding_tokens ||= company_onboarding.tokens
    else
      add_error(I18n.t('flash.not_found', model: 'Company onboarding'))
    end
  end

  def approve_onboarding
    return if company_onboarding.is_a?(CompanyOnboarding) && company_onboarding.pending_review?

    case params[:approval]
    when 'approved'
      approve
    when 'disapproved'
      disapprove
    end
  end

  def approve
    company_onboarding.tokens.create!(status: 0, purpose: 0) unless onboarding_tokens.where(status: 0, purpose: 0)&.any?

    if company_onboarding.approved!
      CompanyOnboardingMailer.with(company_onboarding: company_onboarding).approve.deliver_later
      assign_data(company_onboarding)
    else
      add_error(I18n.t('flash.something_wrong'))
    end
  rescue ActiveRecord::RecordInvalid => e
    add_error(e.message)
  end

  def disapprove
    company_onboarding.tokens.create!(status: 0, purpose: 1) unless onboarding_tokens.where(status: 0, purpose: 1)&.any?

    if company_onboarding.update(approval: :disapproved, reason_for_disapproval: params[:reason_for_disapproval])
      CompanyOnboardingMailer.with(company_onboarding: company_onboarding,
                                   reason_for_disapproval: params[:reason_for_disapproval]).disapprove.deliver_later
      assign_data(company_onboarding)
    else
      add_error(I18n.t('flash.something_wrong'))
    end
  end
end
