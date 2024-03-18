# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lot do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:asking_price_cents) }

    context 'when auction is live' do
      let!(:auction) { create(:auction, :with_company, starts_at: 2.days.ago, closes_at: 4.days.from_now) }
      let!(:lot) {  create(:lot, auction: auction, collaborator: auction.company) }

      it 'no update occurs', :aggregate_failures do
        expect { lot.update(description: 'New one') }.not_to change { lot.reload.description }
        expect(lot.errors.full_messages).to include(I18n.t('models.lot.errors.manipulate_lot'))
      end

      it 'no destroy occurs', :aggregate_failures do
        expect { lot.destroy }.to raise_error(StandardError, I18n.t('models.lot.errors.manipulate_lot'))
        expect(described_class.count).to eq(1)
      end
    end

    context 'when creating auction' do
      let!(:auction) { create(:auction, :with_company, starts_at: 2.days.ago, closes_at: 4.days.from_now) }
      let!(:collaborator) { create(:collaborator, auction: auction) }
      let(:lot_by_collaborator) { build(:lot, auction: auction, collaborator: collaborator.collaborator) }
      let(:lot_by_auctioneer) { build(:lot, auction: auction, collaborator: auction.company) }

      it 'collaborating company is allowed', :aggregate_failures do
        expect(lot_by_collaborator).to be_valid
        expect(lot_by_collaborator.collaborator).to eq(collaborator.collaborator)
      end

      it 'auctioneer is allowed', :aggregate_failures do
        expect(lot_by_auctioneer).to be_valid
        expect(lot_by_auctioneer.collaborator).to eq(auction.company)
      end
    end
  end

  describe 'relations' do
    it { is_expected.to belong_to(:auction) }
    it { is_expected.to belong_to(:collaborator) }
    it { is_expected.to have_one_attached(:image) }
  end

  describe 'factories' do
    let(:lot) { create(:lot, :with_auction, :with_collaborator) }

    it { expect { lot }.to change(described_class, :count).by(1) }
  end
end
