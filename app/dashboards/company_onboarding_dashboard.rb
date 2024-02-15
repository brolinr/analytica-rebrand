require "administrate/base_dashboard"

class CompanyOnboardingDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::String,
    about: Field::Text,
    address: Field::String,
    approval: Field::Select.with_options(searchable: false, collection: ->(field) { field.resource.class.send(field.attribute.to_s.pluralize).keys }),
    buyer: Field::Boolean,
    certificate_of_incorporation_attachment: Field::HasOne,
    certificate_of_incorporation_blob: Field::HasOne,
    city: Field::String,
    cr5_attachment: Field::HasOne,
    cr5_blob: Field::HasOne,
    cr6_attachment: Field::HasOne,
    cr6_blob: Field::HasOne,
    email: Field::String,
    logo_attachment: Field::HasOne,
    logo_blob: Field::HasOne,
    name: Field::String,
    phone: Field::String,
    reason_for_disapproval: Field::Text,
    supplier: Field::Boolean,
    tax_clearance_attachment: Field::HasOne,
    tax_clearance_blob: Field::HasOne,
    terms: Field::Boolean,
    tokens: Field::HasMany,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    about
    address
    approval
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    about
    address
    approval
    buyer
    certificate_of_incorporation_attachment
    certificate_of_incorporation_blob
    city
    cr5_attachment
    cr5_blob
    cr6_attachment
    cr6_blob
    email
    logo_attachment
    logo_blob
    name
    phone
    reason_for_disapproval
    supplier
    tax_clearance_attachment
    tax_clearance_blob
    terms
    tokens
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    about
    address
    approval
    buyer
    certificate_of_incorporation_attachment
    certificate_of_incorporation_blob
    city
    cr5_attachment
    cr5_blob
    cr6_attachment
    cr6_blob
    email
    logo_attachment
    logo_blob
    name
    phone
    reason_for_disapproval
    supplier
    tax_clearance_attachment
    tax_clearance_blob
    terms
    tokens
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how company onboardings are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(company_onboarding)
  #   "CompanyOnboarding ##{company_onboarding.id}"
  # end
end
