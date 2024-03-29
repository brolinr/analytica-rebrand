# frozen_string_literal: true

class CompanyOnboardingMailer < ApplicationMailer
  before_action :onboarding

  def approve
    @url = Rails.application.routes.url_helpers.new_company_url(approval_token: associated_token(0, 0).secret)
    mail(from: ENV['DELIVERY_SUPPORT_EMAIL'] ,to: onboarding.email, subject: I18n.t('mailers.approve.subject'))
  end

  def disapprove
    @url = Rails.application.routes.url_helpers.edit_company_onboarding_url(id: onboarding.id,
                                                                            disapproval_token: associated_token(
                                                                              1, 0
                                                                            ).secret)
    mail(from: ENV['DELIVERY_SUPPORT_EMAIL'], to: onboarding.email, subject: I18n.t('mailers.disapprove.subject'))
  end

  private

  def onboarding
    @onboarding ||= params[:company_onboarding].reload
  end

  def associated_token(purpose, status)
    onboarding.tokens.find_by(purpose: purpose, status: status)
  end
end
