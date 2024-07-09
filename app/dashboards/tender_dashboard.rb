require "administrate/base_dashboard"

class TenderDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String,
    administrator: Field::BelongsTo,
    collections: Field::BelongsTo,
    deadline: Field::DateTime,
    location: Field::String,
    organisation: Field::String,
    tags: Field::HasMany,
    title: Field::String,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    title
    administrator
    tags
    location
    organisation
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    title
    location
    organisation
    administrator
    collections
    tags
    deadline
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    tags
  ].freeze

  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how tenders are displayed
  # across all pages of the admin dashboard.
  #
  def display_resource(tender)
    tender.title
  end
end
