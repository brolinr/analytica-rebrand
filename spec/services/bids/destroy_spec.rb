# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bids::Destroy do
  subject(:call) { described_class.call(context: { bid: bid }) }

  let(:company) { create(:company, :as_bidder) }
  let(:auction) { create(:auction, :with_company) }
  let(:lot) { create(:lot, collaborator: auction.company, auction: auction) }
  let(:bid) { create(:bid, company: company, lot: lot, amount: lot.asking_price) }

  before { create(:auction_registration, auction: auction, company: company) }

  describe '#call' do
    context 'with existing bid' do
      before { bid }

      it 'destroys bid', :aggregate_failures do
        expect { call }.to change(Bid, :count).from(1).to(0)
        expect(call.data).to be_a(Bid)
        expect(call).to be_success
      end
    end

    context 'with already deletes bid' do
      before { bid.destroy }

      it 'does not delete anything', :aggregate_failures do
        expect { call }.not_to change(Bid, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
