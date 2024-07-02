# frozen_string_literal: true

class CompanyOnboardingPolicy < ApplicationPolicy
  def update?
    record&.tokens&.exists?(status: 0, purpose: 1) && record&.disapprove? && !Company.exists?(email: record.email)
  end
end
