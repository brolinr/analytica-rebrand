# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReverseAuction::BidsController, type: :controller do
  let(:company) { create(:company, :as_bidder) }
  let(:auction) { create(:auction, :with_company) }
  let(:lot) { create(:lot, collaborator: auction.company, auction: auction) }
  let(:bid) { create(:bid, company: company, lot: lot, amount: lot.asking_price) }

  before do
    create(:auction_registration, auction: auction, company: company)
    sign_in(company)
  end

  describe 'POST #create' do
    let(:request) { post :create, params: { lot_id: lot.id, bid: params } }

    context 'with correct params' do
      let(:params) { { amount: lot.asking_price } }

      it 'creates bid', :aggregate_failures do
        expect { request }.to change(Bid, :count).from(0).to(1)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with empty amount' do
      let(:params) { { amount: '' } }

      it 'does not create any bid', :aggregate_failures do
        expect { request }.not_to change(Bid, :count).from(0)
        expect(flash[:error]).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:request) { delete :destroy, params: params }

    context 'with correct params' do
      let(:params) { { lot_id: lot.id, id: bid.id } }

      before { bid }

      it 'destroys bid', :aggregate_failures do
        expect { request }.to change(Bid, :count).from(1).to(0)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with deleted bid' do
      let(:params) { { lot_id: lot.id, id: bid.id } }

      before { bid.destroy }

      it 'does not create any bid', :aggregate_failures do
        expect { request }.not_to change(Bid, :count).from(0)
        expect(flash[:error]).not_to be_empty
      end
    end
  end
end
