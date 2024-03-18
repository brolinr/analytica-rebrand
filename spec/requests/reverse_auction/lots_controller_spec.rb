# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReverseAuction::LotsController, type: :controller do
  let(:company) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company, starts_at: 2.days.ago, closes_at: 1.day.ago) }
  let(:collaborator) { create(:collaborator, auction: auction).collaborator }
  let(:lot) { create(:lot, auction: auction, collaborator: company) }

  describe 'POST #create' do
    let(:request) { post :create, params: { auction_id: auction.id, lot: attributes_for(:lot) } }

    context 'when collaborating company creates' do
      before { sign_in(collaborator) }

      it 'creates successfully', :aggregate_failures do
        expect { request }.to change(Lot, :count).from(0).to(1)
        expect(Lot.last.collaborator_id).to eq(collaborator.id)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'when auctioning company creates' do
      before { sign_in(company) }

      it 'creates successfully', :aggregate_failures do
        expect { request }.to change(Lot, :count).from(0).to(1)
        expect(Lot.last.collaborator_id).to eq(company.id)
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe 'PUT #update' do
    let(:request) { put :update, params: { auction_id: auction.id, id: lot.id, lot: params } }

    context 'when auction is pending' do
      let(:params) { { title: 'New one' } }

      before do
        sign_in(company)
        lot
        auction.update(starts_at: 1.day.from_now, closes_at: 4.days.from_now)
      end

      it 'update the lot', :aggregate_failures do
        expect { request }.to change { lot.reload.title }.to(params[:title])
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'when auction is live' do
      let(:params) { { title: 'New one' } }

      before do
        sign_in(company)
        auction.update(closes_at: 2.days.from_now)
        lot
      end

      it 'update the lot', :aggregate_failures do
        expect { request }.not_to change(lot, :attributes)
        expect(flash[:error]).not_to be_empty
      end
    end

    context 'when auction is closed', pending: 'need to add expiry states' do
      let(:params) { { title: 'New one' } }

      before do
        auction.update(closes_at: 2.days.ago, starts_at: 5.days.ago)
        sign_in(company)
        lot
      end

      it 'update the lot', :aggregate_failures do
        expect { request }.not_to change { lot.reload.attributes }
        expect(flash[:notice]).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:request) { delete :destroy, params: { id: lot.id, auction_id: auction.id } }

    context 'with existing lot' do
      before do
        sign_in(company)
        lot
      end

      it 'destroy lot', :aggregate_failures do
        expect { request }.to change(Lot, :count).from(1).to(0)
        expect(flash[:notice]).not_to be_empty
      end
    end
  end
end
