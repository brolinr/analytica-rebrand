# frozen_string_literal: true

FactoryBot.define do
  factory :bid do
    amount { rand(10) }
    lot { create(:lot) }
    company { create(:company, :as_bidder) }
  end
end
