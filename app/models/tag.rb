class Tag < ApplicationRecord
  belongs_to :taggable, polymorphic: true, optional: true

  validates :title, presence: true
end
