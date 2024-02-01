# frozen_string_literal: true

FactoryBot.define do
  factory(:token) do
    status { rand(0..1) }
    purpose { rand(0..1) }
    generator { create(:company_onboarding) }
  end
end
