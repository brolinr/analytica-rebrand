# frozen_string_literal: true

require 'administrate/base_dashboard'

class CompanyDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::String,
    about: Field::Text,
    address: Field::String,
    bidder: Field::Boolean,
    city: Field::String,
    email: Field::String,
    name: Field::String,
    phone: Field::String,
    supplier: Field::Boolean,
    terms: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    name
    address
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    about
    address
    bidder
    city
    email
    name
    phone
    supplier
    terms
    created_at
    updated_at
  ].freeze

  FORM_ATTRIBUTES = %i[
    about
    address
    bidder
    city
    email
    name
    phone
    supplier
    terms
  ].freeze

  def display_resource(company)
    company.name
  end
end
