# frozen_string_literal: true

FactoryBot.define do
  factory :lot do
    title { FFaker::Product.name }
    description { FFaker::Lorem.paragraph }
    asking_price { rand(200) }
    image { image_upload }
    trait :with_auction do
      auction { create(:auction, :with_company) }
    end

    trait :with_collaborator do
      collaborator { auction.company }
    end
  end
end

def image_upload
  Rack::Test::UploadedFile.new(Tempfile.new(%w[test .png]), 'image/png')
end
