# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuctionRegistrations::Update do
  subject(:call) { described_class.call(context: { auction_registration: auction_registration }, params: params) }

  let(:company) { create(:company, :as_supplier) }
  let(:company_2) { create(:company, :as_bidder) }
  let(:auction) { create(:auction, company: company) }
  let(:auction_registration) { create(:auction_registration, auction: auction, company: company_2) }

  describe '#call' do
    context 'with params to accept' do
      let(:params) { { approval: 'approve' } }

      it 'accepts registration', :aggregate_failures do
        expect { call }.to change { auction_registration.reload.approval }.from('pending').to('approve')
        expect(call.data).to be_a(AuctionRegistration)
        expect(call).to be_success
      end
    end

    context 'with params to decline' do
      let(:params) { { approval: 'decline' } }

      it 'declines registration', :aggregate_failures do
        expect { call }.to change { auction_registration.reload.approval }.from('pending').to('decline')
        expect(call.data).to be_a(AuctionRegistration)
        expect(call).to be_success
      end
    end
  end
end
