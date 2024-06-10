class Tender < ApplicationRecord
  has_rich_text :description

  belongs_to :administrator
  has_many :tags, as: :taggable, dependent: :nullify
  has_many :collections, as: :collectable, dependent: :nullify

  validates :title, :description, :deadline, :location, :organisation, presence: true
end
