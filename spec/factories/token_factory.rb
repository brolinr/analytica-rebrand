# frozen_string_literal: true

FactoryBot.define do
  factory(:token) do
    status { 0 }
    purpose { 1 }
    association :generator, factory: :company_onboarding
  end
end
