# frozen_string_literal: true

FactoryBot.define do
  factory(:auction_registration) do
    delivery_phone { FFaker::PhoneNumberAU.international_mobile_phone_number }
    delivery_city { FFaker::Address.city }
    delivery_address { FFaker::AddressBR.street_address }
    company { create(:company, :as_bidder) }
    auction { create(:auction, :with_company) }
    terms { '1' }
  end
end
