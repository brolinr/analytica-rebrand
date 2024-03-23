# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auctions::Destroy do
  subject(:call) { described_class.call(context: { auction: auction }) }

  let(:company) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company) }

  describe '#call' do
    context 'with existing auction' do
      before { auction }

      it 'deletes auction', :aggregate_failures do
        expect { call }.to change(Auction, :count).from(1).to(0)
        expect(call).to be_success
        expect(call.data).to be_a(Auction)
      end
    end
  end
end
