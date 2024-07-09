FactoryBot.define do
  factory(:tender) do
    title { FFaker::Lorem.word }
    description { FFaker::Lorem.paragraph(3) }
    deadline { 5.days.from_now }
    organisation { FFaker::Company.name }
    location { FFaker::Address.city }
  end
end
