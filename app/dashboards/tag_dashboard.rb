require "administrate/base_dashboard"

class TagDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::String,
    title: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    title
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    title
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(tag)
    tag.title
  end
end
