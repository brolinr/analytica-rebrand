# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/company_onboarding_mailer
class CompanyOnboardingMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/company_onboarding_mailer/approve
  def approve
    CompanyOnboardingMailer.approve
  end

  # Preview this email at http://localhost:3000/rails/mailers/company_onboarding_mailer/dissaprove
  def dissaprove
    CompanyOnboardingMailer.dissaprove
  end
end
