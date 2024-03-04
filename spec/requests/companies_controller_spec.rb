# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:company_onboarding) { create(:company_onboarding, :approve) }
  let(:token) { create(:token, generator: company_onboarding) }

  describe 'GET new' do
    context 'when company exists' do
      let(:request) { get :new, params: { approval_token: '' } }

      it { expect(request).to redirect_to(root_path) }
    end
  end

  describe 'POST create' do
    let(:request) { post :create, params: params }

    context 'with password params' do
      let(:params) { { approval_token: token.secret, password: 'password', password_confirmation: 'password' } }

      it 'creates a company', :aggregate_failures do
        expect { request }.to change(Company, :count).by(1)
        expect(Company.last.email).to eq(company_onboarding.email)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'without password params' do
      let(:params) { { approval_token: token.secret } }

      it 'does not create a company', :aggregate_failures do
        expect { request }.not_to change(Company, :count)
        expect(response).to redirect_to(new_company_path(approval_token: token.secret))
        expect(flash.now[:error]).not_to be_empty
      end
    end
  end
end
