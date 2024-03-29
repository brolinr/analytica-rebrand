# frozen_string_literal: true

class CompanyOnboardingsController < ApplicationController
  before_action :authenticate_administrator!, only: %i[approve index show]
  before_action :redirect_signed_in_user, except:  %i[approve index show]

  before_action :onboarding_valid?, except: %i[new create index]
  before_action :approval_valid?, only: :edit
  before_action :token_valid?, only: :edit

  def new
    @company_onboarding = CompanyOnboarding.new
  end

  def create
    result = CompanyOnboardings::Create.call(params: onboarding_params)

    error_or_redirect(
      object: result,
      success_path: root_path,
      failure_path: new_company_onboarding_path,
      success_string_key: 'flash.onboarded'
    )
  end

  def show; end

  def index
    @q = CompanyOnboarding.ransack(params[:q], approval: 'pending_review')
    @pagy, @company_onboardings = pagy(@q.result.where(approval: 'pending_review'))
  end

  def edit; end

  def update
    result = CompanyOnboardings::Update.call(params: onboarding_params,
                                             context: { company_onboarding: company_onboarding })
    token = company_onboarding.tokens.find_by(status: 'active', purpose: 'onboarding_edit')

    error_or_redirect(
      object: result,
      success_path: root_path,
      failure_path: token.nil? ? root_path : edit_company_onboarding_path(disapproval_token: token.secret),
      success_string_key: 'flash.updated'
    )
  end

  def approve
    result = CompanyOnboardings::Approve.call(
      params: approval_params, context: { company_onboarding: company_onboarding }
    )

    error_or_redirect(
      object: result,
      success_path: company_onboardings_path,
      failure_path: company_onboardings_path,
      i18n_scope: 'controllers.company_onboardings.approve'
    )
  end

  private

  def onboarding_params
    params.require(:company_onboarding).permit(
      :email, :name, :phone, :address, :city,
      :certificate_of_incorporation, :tax_clearance,
      :cr5, :cr6, :terms, :password,
      :password_confirmation, :current_password
    )
  end

  def approval_params
    params.require(:company_onboarding).permit(:approval, :reason_for_disapproval)
  end

  def company_onboarding
    @company_onboarding ||= CompanyOnboarding.find(params[:id])
  end

  def onboarding_valid?
    if company_onboarding.is_a?(CompanyOnboarding) && Company.exists?(email: company_onboarding.email)
      redirect_to root_path, flash: { alert: I18n.t('flash.something_wrong') }
    end
  end

  def approval_valid?
    redirect_to root_path, flash: { alert: I18n.t('flash.something_wrong') } unless company_onboarding&.disapprove?
  end

  def token_valid?
    token = company_onboarding&.tokens&.find_by(status: 0, purpose: 1)
    redirect_to root_path, flash: { alert: I18n.t('flash.something_wrong') } if token.nil? || token.void?
  end
end
