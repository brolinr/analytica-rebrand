# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auction do
  let(:auction) { create(:auction, :with_company) }

  describe 'relations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to have_many(:collaborators).dependent(:destroy) }
    it { is_expected.to have_many(:auction_registrations).dependent(:destroy) }
    it { is_expected.to have_one_attached(:image) }
    it { is_expected.to have_rich_text(:description) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:closes_at) }

    context 'when validating dates' do
      it 'start should not be later than closes_at' do
        auction.closes_at = auction.starts_at - 3.days
        expect(auction).not_to be_valid
      end
    end

    context 'when validating companies' do
      before { auction.company.update!(supplier: false, bidder: true) }

      it { expect(auction).not_to be_valid }
    end
  end

  describe 'factories' do
    it { expect { auction }.to change(described_class, :count).by(1) }
  end
end
