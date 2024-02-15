# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend

  def redirect_signed_in_user
    if company_signed_in? || administrator_signed_in?
      redirect_to root_path, notice: "You are already signed in."
    end
  end
end
