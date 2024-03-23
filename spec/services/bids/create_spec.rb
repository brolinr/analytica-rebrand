# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bids::Create do
  subject(:call) { described_class.call(params: params, context: { lot: lot, company: company }) }

  let(:company) { create(:company, :as_bidder) }
  let(:auction) { create(:auction, :with_company) }
  let(:lot) { create(:lot, collaborator: auction.company, auction: auction) }

  before { create(:auction_registration, auction: auction, company: company) }

  describe '#call' do
    context 'with proper params' do
      let(:params) { { amount: lot.asking_price } }

      it 'create bid', :aggregate_failures do
        expect { call }.to change(Bid, :count).from(0).to(1)
        expect(call.data).to be_a(Bid)
        expect(call).to be_success
      end
    end
  end
end
