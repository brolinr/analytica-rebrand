# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyOnboardings::Approve do
  subject(:call) { described_class.call(params: params, context: { company_onboarding: company_onboarding }) }

  let(:company_onboarding) { create(:company_onboarding) }

  describe '#call' do
    context 'when params disapprove' do
      let(:params) { { approval: 'disapproved' } }

      it 'disapproves onboarding', :aggregate_failures do
        expect { call }.to change { company_onboarding.tokens.count }.by(1)
        expect(company_onboarding.reload.approval).to eq('disapproved')
        expect(call.data).to be_a(CompanyOnboarding)
        expect(call).to be_success
      end
    end

    context 'when params approve' do
      let(:params) { { approval: 'approved' } }

      it 'approves onboarding', :aggregate_failures do
        expect { call }.to change { company_onboarding.tokens.count }.by(1)
        expect(company_onboarding.reload.approval).to eq('approved')
        expect(call.data).to be_a(CompanyOnboarding)
        expect(call).to be_success
      end
    end

    context 'when onboarding is already approved' do
      before { company_onboarding.approved! }

      let(:params) { { approval: 'approved' } }

      it 'does not approve onboarding', :aggregate_failures do
        expect { call }.not_to change { company_onboarding.tokens.count }.from(0)
        expect(company_onboarding.reload.approval).to eq('approved')
        expect(call.errors).to include(I18n.t('flash.approval_not_pending'))
        expect(call).to be_failure
      end
    end

    context 'when onboarding is already disapproved' do
      before { company_onboarding.disapproved! }

      let(:params) { { approval: 'disapproved' } }

      it 'does not disapprove onboarding', :aggregate_failures do
        expect { call }.not_to change { company_onboarding.tokens.count }.from(0)
        expect(company_onboarding.reload.approval).to eq('disapproved')
        expect(call.errors).to include(I18n.t('flash.approval_not_pending'))
        expect(call).to be_failure
      end
    end
  end
end
