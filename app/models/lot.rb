# frozen_string_literal: true

class Lot < ApplicationRecord
  scope :collected, ->(company_id, lot_id) { Collection.where(company_id: company_id, lot_id: lot_id) }
  before_destroy do
    raise StandardError, I18n.t('models.lot.errors.manipulate_lot') if Auction.live.pluck(:id).include?(auction_id)
  end

  before_update do
    if Auction.live.pluck(:id).include?(auction_id)
      errors.add(:base, I18n.t('models.lot.errors.manipulate_lot'))
      throw(:abort)
    end
  end

  monetize :asking_price_cents

  belongs_to :auction
  belongs_to :collaborator, polymorphic: true
  has_many :collections, dependent: :nullify

  has_one_attached :image

  validates :title, :description, :image, :asking_price_cents, presence: true
  validate :validate_collaborator

  def self.ransackable_attributes(_auth_object = nil)
    %w[asking_price_cents auction_id collaborator_id collaborator_type created_at description id title updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[auction collaborator image_attachment image_blob]
  end

  private

  def validate_collaborator # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
    errors.add(:base, I18n.t('models.lot.errors.not_a_company')) unless collaborator && collaborator_type == 'Company'

    return if auction&.company_id == collaborator_id

    unless auction&.collaborators&.pluck(:collaborator_id)&.include?(collaborator_id)
      errors.add(:base, I18n.t('models.common.not_authorized'))
    end
  end
end
