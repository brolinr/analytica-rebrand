# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Companies::Create do
  subject(:call) { described_class.call(params: params, context: { company_onboarding: company_onboarding }) }

  let(:company_onboarding) { create(:company_onboarding, :approve) }
  let(:password) { FFaker::Internet.password }

  describe '#call' do
    context 'with approve onboarding' do
      let(:params) { { password: password, password_confirmation: password } }

      it 'creates company', :aggregate_failures do
        expect { call }.to change(Company, :count).by(1)
        expect(call.data).to be_a(Company)
        expect(call).to be_success
      end
    end

    context 'with onboarding disapprove/pending_review' do
      before { company_onboarding.disapprove! }

      let(:params) { { password: password, password_confirmation: password } }

      it 'does not create company', :aggregate_failures do
        expect { call }.not_to change(Company, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end

    context 'with unsaved company' do
      let(:params) { { password: 'passwo', password_confirmation: 'password' } }

      it 'does not create company', :aggregate_failures do
        expect { call }.not_to change(Company, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
