# frozen_string_literal: true

class ErrorsController < ApplicationController
  def not_found
    render status: :not_found, layout: 'layouts/errors_application'
  end

  def internal_server_error
    render status: :internal_server_error, layout: 'layouts/errors_application'
  end

  def unprocessable_content
    render status: :unprocessable_entity, layout: 'layouts/errors_application'
  end
end
