# frozen_string_literal: true

class Company < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  scope :bidders, -> { where(bidder: true) }
  scope :suppliers, -> { where(supplier: true) }

  validates :about, length: { maximum: 300 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :city, presence: true, length: { maximum: 50 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { minimum: 10, maximum: 16 }, uniqueness: true

  has_many :auctions, dependent: :destroy
  has_many :collaborations, as: :collaborator, class_name: 'Collaborator', dependent: :destroy
  has_many :lots, as: :collaborator, class_name: 'Lot', dependent: :nullify
  has_many :auction_registrations, dependent: :destroy
  has_many :collections, dependent: :destroy
end
