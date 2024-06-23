# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    company { create(:company) }
    collectable { create(:lot, :with_auction, :with_collaborator) }
  end
end
