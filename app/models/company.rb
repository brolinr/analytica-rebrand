# frozen_string_literal: true

class Company < ApplicationRecord
  include Company::Attachments
  include Company::Validations

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
end
