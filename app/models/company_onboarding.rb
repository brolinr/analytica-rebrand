# frozen_string_literal: true

class CompanyOnboarding < ApplicationRecord
  I18N_SCOPE = 'models.company.errors'

  enum approval: { pending_review: 0, approved: 1, disapproved: 2 }

  has_one_attached :certificate_of_incorporation
  has_one_attached :tax_clearance
  has_one_attached :cr5
  has_one_attached :cr6
  has_one_attached :logo
  has_many :tokens, as: :generator, dependent: :destroy

  validates :reason_for_disapproval, length: { maximum: 300 }
  validates :about, length: { maximum: 300 }
  validates :name, presence: true, length: { maximum: 50 }
  validates :city, presence: true, length: { maximum: 50 }
  validates :address, presence: true, length: { maximum: 50 }
  validates :phone, presence: true, length: { minimum: 10, maximum: 16 }, uniqueness: true
  validates :terms, presence: { message: I18n.t('terms_and_conditions.presence', scope: I18N_SCOPE) }
  validates :certificate_of_incorporation,
            presence: { message: I18n.t('certificate_of_incorporation.presence', scope: I18N_SCOPE) },
            content_type: { in: 'application/pdf', message: I18n.t('pdf_format', scope: I18N_SCOPE) },
            size: { less_than: 5.megabytes, message: I18n.t('less_than_5mb', scope: I18N_SCOPE) }
  validates :tax_clearance,
            presence: { message: I18n.t('tax_clearance.presence', scope: I18N_SCOPE) },
            content_type: { in: 'application/pdf', message: I18n.t('pdf_format', scope: I18N_SCOPE) },
            size: { less_than: 5.megabytes, message: I18n.t('less_than_5mb', scope: I18N_SCOPE) }
  validates :cr5,
            presence: { message: I18n.t('cr5.presence', scope: I18N_SCOPE) },
            content_type: { in: 'application/pdf', message: I18n.t('pdf_format', scope: I18N_SCOPE) },
            size: { less_than: 5.megabytes, message: I18n.t('less_than_5mb', scope: I18N_SCOPE) }
  validates :cr6,
            presence: { message: I18n.t('cr6.presence', scope: I18N_SCOPE) },
            content_type: { in: 'application/pdf', message: I18n.t('pdf_format', scope: I18N_SCOPE) },
            size: { less_than: 5.megabytes, message: I18n.t('less_than_5mb', scope: I18N_SCOPE) }
  validates :logo,
            presence: false,
            content_type: { in: %w[image/jpeg image/png], message: I18n.t('image_format', scope: I18N_SCOPE) },
            size: { less_than: 5.megabytes, message: I18n.t('less_than_5mb', scope: I18N_SCOPE) }

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      about address approval buyer created_at email id
      location name phone seller terms_and_conditions updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[
      certificate_of_incorporation_attachment certificate_of_incorporation_blob
      cr5_attachment cr5_blob cr6_attachment cr6_blob logo_attachment logo_blob
      tax_clearance_attachment tax_clearance_blob
    ]
  end
end
