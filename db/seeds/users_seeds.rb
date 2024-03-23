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

22.times do |time|
  company = generate_company

  if time > 3
    company.bidder = true
    company.password = 'password'
    company.password_confirmation = 'password'
    company.save!
    company.confirm
  elsif time > 13
    company.supplier = true
    company.save!
    company.confirm
  else
    company.save!
  end
end

70.times do |time|
  company_onboarding = generate_company_onboarding
  company_onboarding.save
  if time < 10
    company_onboarding.approve!
  elsif time < 30
    company_onboarding.disapprove!
  end
end
