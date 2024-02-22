# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
    name { FFaker::Company.name }
    phone { FFaker::PhoneNumberAU.international_mobile_phone_number }
    city { FFaker::Address.city }
    address { FFaker::AddressBR.street_address }
    terms { true }
    confirmed_at { Time.zone.now }

    trait :as_supplier do
      supplier { true }
    end
  end
end
