# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collaborators::Update do
  subject(:call) { described_class.call(context: { collaborator: collaborator }, params: params) }

  let(:company) { create(:company, :as_supplier) }
  let(:company_2) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company) }
  let(:collaborator) { create(:collaborator, auction: auction, collaborator: company_2) }

  describe '#call' do
    context 'with params to accepting a request' do
      let(:params) { { acceptance_status: 'accepted' } }

      it 'accepts a request', :aggregate_failures do
        expect { call }.to change { collaborator.reload.acceptance_status }.from('pending').to('accepted')
        expect(call.data).to be_a(Collaborator)
        expect(call).to be_success
      end
    end

    context 'with params to decline a request' do
      let(:params) { { acceptance_status: 'declined' } }

      it 'declines a request a request', :aggregate_failures do
        expect { call }.to change { collaborator.reload.acceptance_status }.from('pending').to('declined')
        expect(call.data).to be_a(Collaborator)
        expect(call).to be_success
      end
    end

    context 'with params to accept a declined colaboration' do
      before { collaborator.declined! }

      let(:params) { { acceptance_status: 'accepted' } }

      it 'does not update collaborator' do
        expect { call }.not_to change { collaborator.reload.attributes }
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end

    context 'with empty acceptance_status on params' do
      before { collaborator.accepted! }

      let(:params) { { acceptance_status: '' } }

      it 'does not update collaborator' do
        expect { call }.not_to change { collaborator.reload.attributes }
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end

    context 'with params to decline an accepted colaboration' do
      before { collaborator.accepted! }

      let(:params) { { acceptance_status: 'declined' } }

      it 'does not update collaborator' do
        expect { call }.not_to change { collaborator.reload.attributes }
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
