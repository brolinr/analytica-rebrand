# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuctionRegistration do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:approval) }
    it { is_expected.to validate_presence_of(:delivery_city) }
    it { is_expected.to validate_presence_of(:delivery_address) }
    it { is_expected.to validate_presence_of(:delivery_phone) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:auction) }
  end

  describe 'factories' do
    let(:auction_registration) { create(:auction_registration) }

    it 'creates registration' do
      expect { auction_registration }.to change(described_class, :count).from(0).to(1)
    end
  end
end
