# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReverseAuction::AuctionRegistrationsController, type: :controller do
  let(:company) { create(:company, :as_supplier) }
  let(:company_2) { create(:company, :as_bidder) }
  let(:auction) { create(:auction, company: company) }
  let(:auction_registration) { create(:auction_registration, auction: auction, company: company_2) }

  describe 'POST #create' do
    before { sign_in company_2 }

    let(:request) { post :create, params: params }

    context 'with correct params' do
      let(:params) do
        {
          auction_id: auction.id,
          auction_registration: attributes_for(:auction_registration, company: nil, auction: nil)
        }
      end

      it 'creates registrations', :aggregate_failures do
        expect { request }.to change(AuctionRegistration, :count).from(0).to(1)
        expect(response).to redirect_to reverse_auction_auction_path(auction)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with incorrect params' do
      let(:params) { { auction_id: 'nil', auction_registration: { invalid: :approve } } }

      it 'does not creates registrations', :aggregate_failures do
        expect { request }.not_to change(AuctionRegistration, :count).from(0)
        expect(response).to redirect_to reverse_auction_live_auctions_path
        expect(flash[:error]).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    before do
      sign_in company
      auction_registration
    end

    let(:request) { put :update, params: params }

    context 'with params to accept' do
      let(:params) do
        { auction_id: auction.id, id: auction_registration.id, auction_registration: { approval: 'approve' } }
      end

      it 'updates registrations', :aggregate_failures do
        expect { request }.to change { auction_registration.reload.approval }.from('pending').to('approve')
        expect(response).to redirect_to reverse_auction_auction_path(auction)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with params to decline' do
      let(:params) do
        { auction_id: auction.id, id: auction_registration.id, auction_registration: { approval: 'decline' } }
      end

      it 'updates registrations', :aggregate_failures do
        expect { request }.to change { auction_registration.reload.approval }.from('pending').to('decline')
        expect(response).to redirect_to reverse_auction_auction_path(auction)
        expect(flash[:notice]).not_to be_empty
      end
    end
  end
end
