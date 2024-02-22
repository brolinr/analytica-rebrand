# frozen_string_literal: true

FactoryBot.define do
  factory(:collaborator) do
    company { create(:company, :as_supplier) }
    auction { create(:auction, :with_company) }
  end
end
