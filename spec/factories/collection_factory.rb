# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    company { create(:company) }
    lot { create(:lot) }
  end
end
