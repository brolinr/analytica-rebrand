# frozen_string_literal: true

class Collaborator < ApplicationRecord
  enum :acceptance_status, { pending: 0, accept: 1, decline: 2 }

  scope :pending_requests, -> { where(acceptance_status: :pending) }
  scope :accepted, -> { where(acceptance_status: :accept) }
  scope :declined, -> { where(acceptance_status: :decline) }

  belongs_to :collaborator, polymorphic: true
  belongs_to :auction

  has_many :lots, as: :collaborator, class_name: 'Lot', dependent: :nullify

  validates :collaborator_id, uniqueness: { scope: :auction_id, case_sensitive: false } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validate :auction_owners_and_suppliers

  private

  def auction_owners_and_suppliers
    errors.add(:base, 'Only suppliers can collaborate on auctions') unless collaborator&.supplier?
    errors.add(:base, 'No need to add yourself as a collaborator.') if collaborator_id == auction&.company_id
  end
end
