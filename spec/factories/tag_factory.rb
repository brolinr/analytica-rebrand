FactoryBot.define do
  factory(:tag) do
    title { FFaker::Name.first_name }
  end
end