# frozen_string_literal: true

require 'administrate/base_dashboard'

class TokenDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::String,
    expires_at: Field::DateTime,
    generator: Field::Polymorphic,
    purpose: Field::Select.with_options(
      searchable: false, collection: lambda { |field|
                                       field.resource.class.send(field.attribute.to_s.pluralize).keys
                                     }
    ),
    secret: Field::String.with_options(searchable: false),
    status: Field::Select.with_options(
      searchable: false, collection: lambda { |field|
                                       field.resource.class.send(field.attribute.to_s.pluralize).keys
                                     }
    ),
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    expires_at
    generator
    purpose
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    expires_at
    generator
    purpose
    secret
    status
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    expires_at
    generator
    purpose
    secret
    status
  ].freeze

  COLLECTION_FILTERS = {}.freeze
end
