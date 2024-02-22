# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :token_void?, except: :edit
  before_action :company_onboarding, except: :edit
  layout 'reverse_auction', only: :edit

  def new; end

  def create
    result = Companies::Create.call(params: params, context: { company_onboarding: company_onboarding })

    error_or_redirect(
      object: result,
      success_path: root_path,
      failure_path: new_company_path(approval_token: token.secret),
      success_string_key: 'flash.account_created'
    )
  end

  def edit
    redirect_to reverse_auction_dashboards_path, notice: I18n.t('flash.something_wrong') if current_company.id != params[:id].to_i
    @company = current_company
  end

  private

  def token_void?
    redirect_to root_path if token.nil? || token.void?
  end

  def token
    @token ||= Token.find_by(secret: params[:approval_token])
  end

  def company_onboarding
    @company_onboarding ||= token&.generator
  end
end
