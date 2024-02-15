# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper
  include Pagy::Backend

  def redirect_signed_in_user
    redirect_to root_path, notice: I18n.t('already_signed') if company_signed_in? || administrator_signed_in?
  end
end
