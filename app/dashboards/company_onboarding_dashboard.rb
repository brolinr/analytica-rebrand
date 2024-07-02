# frozen_string_literal: true

require 'administrate/base_dashboard'

class CompanyOnboardingDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::String,
    about: Field::Text,
    address: Field::String,
    approval: Field::Select.with_options(
      searchable: false, collection: lambda { |field|
        field.resource.class.send(field.attribute.to_s.pluralize).keys
      }
    ),
    bidder: Field::Boolean,
    city: Field::String,
    email: Field::String,
    name: Field::String,
    phone: Field::String,
    reason_for_disapproval: Field::Text,
    supplier: Field::Boolean,
    terms: Field::Boolean,
    tokens: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    name
    email
    phone
    approval
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[

  ].freeze

  FORM_ATTRIBUTES = %i[

  ].freeze

  COLLECTION_FILTERS = {}.freeze

  def display_resource(company_onboarding)
    company_onboarding.name
  end
end
