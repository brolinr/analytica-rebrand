# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReverseAuction::CollectionsController, type: :controller do
  let(:company) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company) }
  let(:lot) { create(:lot, auction: auction, collaborator: company) }

  before { sign_in(company) }

  describe 'POST #create' do
    let(:request) { post :create, params: { collection: params } }

    context 'with correct params' do
      let(:params) { { lot_id: lot.id } }

      it 'creates collection', :aggregate_failures do
        expect { request }.to change(Collection, :count).from(0).to(1)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with invalid lot id' do
      let(:params) { { lot_id: 'invalid' } }

      it 'does not create any collection', :aggregate_failures do
        expect { request }.not_to change(Collection, :count).from(0)
        expect(flash[:error]).not_to be_empty
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:collection) { create(:collection, lot: lot, company: company) }
    let(:request) { delete :destroy, params: params }

    context 'with correct params' do
      let(:params) { { id: collection.id } }

      before { collection }

      it 'destroys collection', :aggregate_failures do
        expect { request }.to change(Collection, :count).from(1).to(0)
        expect(flash[:notice]).not_to be_empty
      end
    end

    context 'with deleted collection' do
      let(:params) { { id: collection.id } }

      before { collection.destroy }

      it 'does not create any collection', :aggregate_failures do
        expect { request }.not_to change(Collection, :count).from(0)
        expect(flash[:error]).not_to be_empty
      end
    end
  end
end
