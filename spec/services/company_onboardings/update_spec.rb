# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyOnboardings::Update do
  subject(:call) { described_class.call(params: params, context: { company_onboarding: company_onboarding }) }

  let(:company_onboarding) { create(:company_onboarding, :approve) }
  let(:token) { create(:token, generator: company_onboarding, status: 'active', purpose: 1) }

  describe '#call' do
    context 'with valid params' do
      let(:params) { { name: 'Updated name' } }

      it 'updates company onboarding and sets approval to pending', :aggregate_failures do
        expect { call }.to change { company_onboarding.reload.name }.to(params[:name]).and(
          change { token.reload.status }.to('void')
        ).and(change { company_onboarding.reload.approval }.to('pending_review'))
        expect(call.data).to be_a(CompanyOnboarding)
        expect(call).to be_success
      end
    end

    context 'with invalid params' do
      let(:params) { { invalid: 'Updated name' } }

      before { allow(company_onboarding).to receive(:update).and_return(false) }

      it 'does not update company onboarding', :aggregate_failures do
        expect { call }.not_to change { company_onboarding.reload.name }
        expect(company_onboarding.reload.approval).to eq('approve')
        expect(token.reload.status).to eq('active')
      end
    end
  end
end
