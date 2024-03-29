# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :devise_sanitized_params, if: :devise_controller?
  include ApplicationHelper
  include Pagy::Backend

  def redirect_signed_in_user
    redirect_to root_path, notice: I18n.t('already_signed') if company_signed_in? || administrator_signed_in?
  end

  private

  def devise_sanitized_params
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(devise_permitted_params) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(devise_permitted_params) }
  end

  def devise_permitted_params
    %i[email name phone address city password password_confirmation current_password]
  end

  def after_sign_in_path_for(_resource)
    case resource_name
    when :company
      reverse_auction_dashboards_path
    when :administrator
      admin_root_path
    end
  end

  def after_sign_up_path_for(_resource)
    case resource_name
    when :company
      reverse_auction_dashboards_path
    when :administrator
      admin_root_path
    end
  end
end
