# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuctionRegistrations::Create do
  subject(:call) { described_class.call(params: params, context: { company: company_2, auction: auction }) }

  let(:company) { create(:company, :as_supplier) }
  let(:company_2) { create(:company, :as_bidder) }
  let(:auction) { create(:auction, company: company) }
  let(:auction_registration) { create(:auction_registration, auction: auction, company: company_2) }

  describe '#call' do
    context 'with correct params' do
      let(:params) { attributes_for(:auction_registration, company: nil, auction: nil) }

      it 'creates registration', :aggregate_failures do
        expect { call }.to change(AuctionRegistration, :count).from(0).to(1)
        expect(call.data).to be_a(AuctionRegistration)
        expect(call).to be_success
      end
    end
  end
end
