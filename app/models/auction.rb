# frozen_string_literal: true

class Auction < ApplicationRecord
  I18N_SCOPE = 'models.auction.errors'
  scope :live, -> { where('starts_at <= ? AND closes_at >= ?', Time.current, Time.current) }
  scope :collaborated, lambda { |company_id|
                         joins(:collaborators).where(collaborators: { collaborator_id: company_id })
                       }

  belongs_to :company
  has_many :collaborators, dependent: :destroy
  has_many :auction_registrations, dependent: :destroy
  has_many :lots, dependent: :nullify

  has_rich_text :description
  has_one_attached :image

  validates :title, :starts_at, :closes_at, :description, presence: true
  validate :only_supplier_can_create
  validate :starts_before_close

  def self.ransackable_attributes(_auth_object = nil)
    %w[closes_at company_id created_at id starts_at title updated_at]
  end

  private

  def starts_before_close
    return if (starts_at && closes_at) && (starts_at <= closes_at)

    errors.add(:base, I18n.t('deadline_later', scope: I18N_SCOPE))
  end

  def only_supplier_can_create
    return if company&.supplier?

    errors.add(:base, I18n.t('only_supplier', scope: I18N_SCOPE))
  end
end
