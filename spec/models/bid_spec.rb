# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bid do
  describe 'relations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:lot) }
  end

  describe 'validations' do
    let(:company_1) { create(:company, :as_supplier) }
    let(:auction) { create(:auction, company: company_1) }
    let(:lot) { create(:lot, auction: auction, collaborator: company_1, asking_price: 100) }

    it { is_expected.to validate_presence_of(:amount_cents) }

    context 'with unregistered company' do
      let(:company) { create(:company, :as_bidder) }
      let(:bid) { build(:bid, company: company, lot: lot) }

      it 'does not create bid', :aggregate_failures do
        expect(bid).not_to be_valid
        expect(bid.errors.full_messages).to include('Register for the auction to bid')
      end
    end

    context 'when bid is not decremental' do
      let(:company) { create(:company, :as_bidder) }
      let(:bid_1) { create(:bid, company: company, lot: lot, amount: 100) }
      let(:bid) { build(:bid, company: company, lot: lot, amount: 101) }
      let(:bid_3) { build(:bid, company: company, lot: lot, amount: 80) }

      before { create(:auction_registration, auction: auction, company: company) }

      it 'does not create bid', :aggregate_failures do
        expect(bid).not_to be_valid
        expect(bid_3).to be_valid
        expect(bid.errors.full_messages).to include('Your bid should match or be lesser than $100.00')
      end
    end

    context 'when company is not a bidder' do
      let(:company) { create(:company) }
      let(:bid) { build(:bid, company: company, lot: lot) }

      it 'does not create bid', :aggregate_failures do
        expect(bid).not_to be_valid
        expect(bid.errors.full_messages).to include('Subscribe as a bidder to bid')
      end
    end

    context 'when auction is not live' do
      before do
        auction.update(starts_at: 8.days.ago, closes_at: 1.day.ago)
        create(:auction_registration, auction: auction, company: company)
      end

      let(:company) { create(:company, :as_bidder) }
      let(:bid_1) { build(:bid, company: company, lot: lot, amount: 80) }

      it 'rejects bids', :aggregate_failures do
        expect(bid_1).not_to be_valid
        expect(bid_1.errors.full_messages).to eq(['You can only bid when the auction is live!'])
      end
    end
  end
end
