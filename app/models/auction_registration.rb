# frozen_string_literal: true

class AuctionRegistration < ApplicationRecord
  scope :pending_registrations, -> { where(approval: :pending) }
  scope :approved, -> { where(approval: :approve) }
  scope :declined, -> { where(approval: :decline) }

  enum :approval, { pending: 0, approve: 1, decline: 2 }

  belongs_to :auction
  belongs_to :company

  validates :company_id, uniqueness: { scope: :auction_id, case_sensitive: false } # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :approval, presence: true
  validates :terms, presence: true
  validates :delivery_city, presence: true
  validates :delivery_phone, presence: true
  validates :delivery_address, presence: true
  validate :bidders_and_collaborators

  private

  def bidders_and_collaborators # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
    errors.add(:base, 'Only bidders can register on auctions') unless company&.bidder?
    if auction&.collaborators&.accepted&.include?(company) || auction&.company_id == company_id
      errors.add(:base, 'You either own this auction or you are a collaborator')
    end
  end
end
