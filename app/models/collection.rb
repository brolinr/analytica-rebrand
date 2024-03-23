# frozen_string_literal: true

class Collection < ApplicationRecord
  belongs_to :company
  belongs_to :lot
  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :lot_id, uniqueness: {
    message: I18n.t('models.collection.collected'), scope: :company_id, case_sensitive: false
  }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
end
