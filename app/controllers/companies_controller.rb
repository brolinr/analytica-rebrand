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
    if current_company.id != params[:id]
      redirect_to reverse_auction_dashboards_path,
                  notice: I18n.t('flash.something_wrong')
    end
    @company = current_company
  end

  def update
    result = Companies::Update.call(context: { company: current_company }, params: params)

    error_or_redirect(
      object: result,
      success_path: edit_company_path(current_company),
      failure_path: edit_company_path(current_company),
      success_string_key: 'flash.updated'
    )
  end

  private

  def token_void?
    redirect_to root_path if token.nil?
  end

  def token
    @token ||= Token.find_by(secret: params[:approval_token])
  end

  def company_onboarding
    @company_onboarding ||= token&.generator
  end

  def permitteed_params
    params.require(:company).permit %i[email name phone address city password password_confirmation current_password]
  end
end
