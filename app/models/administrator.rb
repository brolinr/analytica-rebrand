# frozen_string_literal: true

class Administrator < ApplicationRecord
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable, :lockable, :trackable
end
