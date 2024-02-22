require 'rails_helper'

RSpec.describe Auctions::Update do
  subject(:call) { described_class.call(params: params, context: { auction: auction }) }

  let(:company) { create(:company, :as_supplier) }
  let(:company_2) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company) }
  let(:collaborator) { create(:collaborator, auction: auction, company: company) }

  describe '#call' do
    before { company }
    context 'with params to update auction' do
      let(:params) { { title: 'New Title' } }

      it 'updates auction', :aggregate_failures do
        expect { call }.to change { auction.reload.title }.to(params[:title])
        expect(call.data).to be_a(Auction)
        expect(call).to be_success
      end
    end

    context 'with params to add collaborators' do
      let(:params) { { collaborator_ids: [company.id, company_2.id, nil, '', 'four', '4'] } }

      before do
        collaborator
        company_2
        company
      end

      it 'updates auction', :aggregate_failures do
        expect { call }.to change(Collaborator, :count).from(1).to(2)
        expect(call.data).to be_a(Auction)
        expect(call).to be_success
      end
    end
  end
end