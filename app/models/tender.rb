class Tender < ApplicationRecord
  has_rich_text :description

  belongs_to :administrator
  has_many :tags, as: :taggable, dependent: :nullify
  belongs_to :collections, polymorphic: true, optional: true

  validates :title, :description, :deadline, :location, :organisation, presence: true
end
