# frozen_string_literal: true

class Bid < ApplicationRecord
  monetize :amount_cents
  has_many_attached :images

  belongs_to :company
  belongs_to :lot

  validates :amount_cents, presence: true
  validate :only_bid_during_live_auction
  validate :company_registered?
  validate :number_of_images
  validate :size_of_each_image
  validate :bid_amount
  validate :bidder

  private

  def number_of_images
    errors.add(:base, 'Only submit 4 images') if images.present? && images.length > 4
  end

  def size_of_each_image
    return if images.blank?

    images.each do |image|
      next unless image.blob.byte_size > 5.megabytes

      errors.add(:base, 'One of your images is too big')
    end
  end

  def bid_amount
    return unless lot&.reload

    if lot.bids.empty? && (amount > lot.asking_price)
      errors.add(:base, "Your bid should match or be lesser than $#{lot.asking_price}")
    end

    if lot.bids.any? && (amount >= lot.bids.except(self).order(:created_at).last.amount)
      errors.add(:base, "Your bid should be lesser than $#{lot.bids.last.amount}")
    end
  end

  def company_registered?
    return unless company && lot
    return if AuctionRegistration.exists?(company_id: company_id, auction_id: lot.auction.id)

    errors.add(:base, 'Register for the auction to bid')
  end

  def bidder
    return if company&.bidder?

    errors.add(:base, 'Subscribe as a bidder to bid')
  end

  def only_bid_during_live_auction
    return if lot && Auction.live.pluck(:id).include?(lot.auction_id)

    errors.add(:base, 'You can only bid when the auction is live!')
  end
end
