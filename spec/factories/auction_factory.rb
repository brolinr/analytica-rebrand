# frozen_string_literal: true

FactoryBot.define do
  factory(:auction) do
    title { "#{FFaker::Product.product_name} Auction" }
    description { FFaker::Book.description }
    starts_at { Time.current }
    closes_at {  starts_at + 5.days }
    association :company, factory: :company

    trait :with_company do
      company { create(:company, :as_supplier) }
    end

  end
end
