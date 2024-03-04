# frozen_string_literal: true

class CompanyOnboardings::Approve < ApplicationService
  def call
    preload(:company_onboarding, :onboarding_tokens)

    transaction { step :approve_onboarding }

    result
  end

  private

  def company_onboarding
    @company_onboarding ||= context[:company_onboarding].reload || CompanyOnboarding.find(params[:id])
  end

  def onboarding_tokens
    @onboarding_tokens ||= company_onboarding.tokens
  end

  def approve_onboarding
    unless company_onboarding.is_a?(CompanyOnboarding) && company_onboarding.pending_review?
      return add_error(I18n.t('flash.approval_not_pending'))
    end

    case params[:approval]
    when 'approve'
      approve
    when 'disapprove'
      disapprove
    end
  end

  def approve
    company_onboarding.tokens.create!(status: 0, purpose: 0) unless onboarding_tokens.any? && onboarding_tokens.where(
      status: 0, purpose: 0
    )&.any?

    if company_onboarding.update(approval: :approve)
      CompanyOnboardingMailer.with(company_onboarding: company_onboarding).approve.deliver_later
      assign_data(company_onboarding)
    else
      handle_validation_errors(company_onboarding)
    end
  end

  def disapprove
    company_onboarding.tokens.create!(status: 0, purpose: 1) unless onboarding_tokens.where(status: 0, purpose: 1)&.any?

    if company_onboarding.update(approval: :disapprove, reason_for_disapproval: params[:reason_for_disapproval])
      CompanyOnboardingMailer.with(company_onboarding: company_onboarding,
                                   reason_for_disapproval: params[:reason_for_disapproval]).disapprove.deliver_later
      assign_data(company_onboarding)
    else
      handle_validation_errors(company_onboarding)
    end
  end
end
