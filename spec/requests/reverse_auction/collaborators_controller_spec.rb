# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReverseAuction::CollaboratorsController, type: :controller do
  let!(:company) { create(:company, :as_supplier) }
  let!(:company_2) { create(:company, :as_supplier) }
  let!(:auction) { create(:auction, company: company) }
  let!(:collaborator) { create(:collaborator, auction: auction, collaborator: company_2) }

  describe 'PUT #update' do
    context 'with params to accept' do
      before { sign_in company }

      let(:request) { put :update, params: { id: collaborator.id, collaborator: { acceptance_status: 'accepted' } } }

      it 'accepts the collaboration', :aggregate_failures do
        expect { request }.to change { collaborator.reload.acceptance_status }.from('pending').to('accepted')
        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to(reverse_auction_collaborators_path)
      end
    end

    context 'with params to decline' do
      before { sign_in company }

      let(:request) { put :update, params: { id: collaborator.id, collaborator: { acceptance_status: 'declined' } } }

      it 'declines the collaboration', :aggregate_failures do
        expect { request }.to change { collaborator.reload.acceptance_status }.from('pending').to('declined')
        expect(flash[:notice]).not_to be_empty
        expect(response).to redirect_to(reverse_auction_collaborators_path)
      end
    end

    context 'with non existing collaborator' do
      before do
        sign_in company
        collaborator.destroy
      end

      let(:request) { put :update, params: { id: collaborator.id, collaborator: { acceptance_status: 'declined' } } }

      it 'declines the collaboration', :aggregate_failures do
        request
        expect(flash[:error]).not_to be_empty
        expect(response).to redirect_to(reverse_auction_collaborators_path)
      end
    end
  end
end
