class Collaborator < ApplicationRecord
  belongs_to :company
  belongs_to :auction

  enum :acceptance_status, { pending: 0, accepted: 1, rejected: 2 }

  validates :company_id, uniqueness: { scope: :auction_id, case_sensitive: false }
  validate :only_supplier_can_collaborate
  #should have a polymorphic of sender, receiver
  private

  def only_supplier_can_collaborate
    return if company&.supplier?

    errors.add(:base, 'Only suppliers can collaborate on auctions')
  end
end
