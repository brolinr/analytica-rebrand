# frozen_string_literal: true

class Collaborator < ApplicationRecord
  enum :acceptance_status, { pending: 0, accepted: 1, declined: 2 }

  scope :pending_requests, -> { where(acceptance_status: :pending) }

  belongs_to :collaborator, polymorphic: true
  belongs_to :auction

  validates :collaborator_id, uniqueness: { scope: :auction_id, case_sensitive: false } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validate :auction_owners_and_suppliers

  private

  def auction_owners_and_suppliers
    errors.add(:base, 'Only suppliers can collaborate on auctions') unless collaborator&.supplier?
    errors.add(:base, 'No need to add yourself as a collaborator.') if collaborator_id == auction&.company_id
  end
end
