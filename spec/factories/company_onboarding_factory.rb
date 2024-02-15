# frozen_string_literal: true
FactoryBot.define do
  factory :company_onboarding do
    email { FFaker::Internet.email }
    name { FFaker::Company.name }
    phone { FFaker::PhoneNumberAU.international_mobile_phone_number }
    city { FFaker::Address.city }
    address { FFaker::AddressBR.street_address }
    terms { true }
    tax_clearance { pdf_upload }
    certificate_of_incorporation { pdf_upload }
    cr5 { pdf_upload }
    cr6 { pdf_upload }

    trait :approved do
      approval { 1 }
    end

    trait :disapproved do
      approval { 2 }
    end

    trait :pending_review do
      approval { 0 }
    end
  end
end

def pdf_upload
  Rack::Test::UploadedFile.new(Tempfile.new(['test', '.pdf']), 'application/pdf')
end
