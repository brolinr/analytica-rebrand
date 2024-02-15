# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CompanyOnboardings::Create do
  subject(:service) { described_class.call(params: params) }

  describe '#call' do
    context 'with valid params' do
      let(:params) { attributes_for(:company_onboarding) }

      it 'creates company onboarding', :aggregate_failures do
        expect { service }.to change(CompanyOnboarding, :count).by(1)
        expect(service).to be_success
        expect(service.data).to be_a(CompanyOnboarding)
      end
    end

    context 'with empty params' do
      let(:params) { {} }

      it 'does not company onboarding', :aggregate_failures do
        expect { service }.not_to change(CompanyOnboarding, :count).from(0)
        expect(service).to be_failure
        expect(service.errors).not_to be_empty
      end
    end
  end
end
