# frozen_string_literal: true

class Token < ApplicationRecord
  # after_create :expire_token
  before_save do |_token|
    generate_token_secret
    set_expiration
  end

  enum purpose: { onboarding_approval: 0, onboarding_edit: 1 }
  enum status: { active: 0, void: 1 }

  belongs_to :generator, polymorphic: true

  validates :purpose, presence: true
  validates :status, presence: true
  validate :validate_token, on: %i[create]

  private

  def generate_token_secret
    return if secret.present?

    loop do
      self.secret = SecureRandom.urlsafe_base64(10).parameterize
      break unless Token.exists?(secret: secret)
    end
  end

  def set_expiration
    self.expires_at = 1.hour.from_now if expires_at.blank?
  end

  def validate_token
    errors.add(:token, 'already exists') if Token.where(generator: generator, purpose: purpose, status: status).any?
  end

  def expire_token
    ExpireTokenJob.perform_at(expires_at, id)
  end
end
