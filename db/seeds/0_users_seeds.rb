# frozen_string_literal: true

def admin
  Administrator.create!(
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password'
  )
end

def generate_company_onboarding
  onboarding = CompanyOnboarding.new(
    email: FFaker::Internet.email,
    name: FFaker::Company.name,
    phone: FFaker::PhoneNumberAU.international_mobile_phone_number,
    city: 'Location A',
    address: FFaker::AddressBR.street_address,
    terms: true
  )

  pdf_path = Rails.root.join('spec/factories/media/documents/test.pdf')

  %i[tax_clearance certificate_of_incorporation cr5 cr6].each do |attachment|
    onboarding.send(attachment).attach(io: File.open(pdf_path), filename: 'test.pdf', content_type: 'application/pdf')
  end

  onboarding
end

def generate_company
  password = FFaker::Internet.password

  Company.new(
    email: FFaker::Internet.email,
    name: FFaker::Company.name,
    phone: FFaker::PhoneNumberAU.international_mobile_phone_number,
    city: 'Location A',
    address: FFaker::AddressBR.street_address,
    password: password,
    password_confirmation: password
  )
end

admin if Administrator.count < 1

5.times do
  company = generate_company

  company.bidder = true
  company.password = 'password'
  company.password_confirmation = 'password'
  company.supplier = true
  company.save!
  company.confirm
end

10.times do
  company_onboarding = generate_company_onboarding
  company_onboarding.save
end
