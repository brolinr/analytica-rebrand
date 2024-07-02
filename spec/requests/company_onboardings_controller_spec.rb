# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyOnboardingsController, type: :controller do
  let(:company_onboarding) { create(:company_onboarding, :disapprove) }
  let(:administrator) { create(:administrator) }
  let(:token) { create(:token, status: 0, purpose: 1, generator: company_onboarding) }

  describe 'GET #new' do
    it 'returns a success response' do
      get :new
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      let(:request) { post :create, params: { company_onboarding: attributes_for(:company_onboarding) } }

      it 'creates a company onboarding', :aggregate_failures do
        expect { request }.to change(CompanyOnboarding, :count).by(1)
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe 'GET #edit' do
    let(:request) { get :edit, params: params }

    context 'with valid token' do
      let(:params) { { id: company_onboarding.id, disapproval_token: token.secret } }

      it 'returns a success response', :aggregate_failures do
        request
        expect(response).not_to redirect_to(root_path)
      end
    end

    context 'with void token' do
      before { token.void! }

      let(:params) { { id: company_onboarding.id, disapproval_token: token.secret } }

      it 'redirects to root path', :aggregate_failures do
        request
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'PATCH #update' do
    let(:request) { patch :update, params: params }

    context 'with valid onboarding' do
      let(:params) do
        {
          id: company_onboarding.id, disapproval_token: token.secret, company_onboarding: { name: 'New name' }
        }
      end

      it 'updates company onboarding and voids token', :aggregate_failures do
        expect { request }.to change { token.reload.status }.to('void').and(
          change { company_onboarding.reload.name }.to('New name')
        )
        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with onboarding existing company for onboarding' do
      before { create(:company, email: company_onboarding.email) }

      let(:params) { { id: company_onboarding.id, disapproval_token: token.secret } }

      it 'Pundit denies request' do
        expect { request }.to raise_error(::Pundit::NotAuthorizedError)
      end
    end
  end

  describe 'POST #approve' do
    before { sign_in administrator }

    context 'with approval params' do
      before { company_onboarding.pending_review! }

      let(:params) { { id: company_onboarding.id, company_onboarding: { approval: 'approve' } } }

      it 'approves company onboarding', :aggregate_failures do
        post :approve, params: params
        expect(company_onboarding.reload.approval).to eq('approve')
        expect(Token.count).to eq(1)
        expect(response).to redirect_to(company_onboardings_path)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with disapproval params' do
      before { company_onboarding.pending_review! }

      let(:params) do
        {
          id: company_onboarding.id,
          company_onboarding: { approval: 'disapprove', reason_for_disapproval: 'NOt eligible' }
        }
      end

      it 'disapproves company onboarding', :aggregate_failures do
        post :approve, params: params
        expect(company_onboarding.reload.approval).to eq('disapprove')
        expect(Token.count).to eq(1)
        expect(response).to redirect_to(company_onboardings_path)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with approve onboarding' do
      before { company_onboarding.approve! }

      let(:params) do
        {
          id: company_onboarding.id,
          company_onboarding: { approval: 'disapprove' }
        }
      end

      it 'does not change approval status', :aggregate_failures do
        post :approve, params: params
        expect(company_onboarding.reload.approval).to eq('approve')
        expect(Token.count).to eq(0)
        expect(response).to redirect_to(company_onboardings_path)
      end
    end
  end
end
