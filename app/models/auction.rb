class Auction < ApplicationRecord
  I18N_SCOPE = 'models.auction.errors'.freeze

  belongs_to :company
  has_many :collaborators, dependent: :destroy

  has_rich_text :description
  has_one_attached :image

  validates :title, :starts_at, :closes_at, :description, presence: true
  validate :only_supplier_can_create
  validate :starts_before_close

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
