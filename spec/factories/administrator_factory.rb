# frozen_string_literal: true

FactoryBot.define do
  factory(:administrator) do
    email { FFaker::Internet.email }
    password { FFaker::Internet.password }
  end
end
