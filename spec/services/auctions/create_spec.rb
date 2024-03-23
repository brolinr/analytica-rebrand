# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Auctions::Create do
  subject(:call) { described_class.call(context: { company: company }, params: params) }

  let(:company) { create(:company, :as_supplier) }
  let(:company_2) { create(:company, :as_supplier) }

  describe 'call' do
    context 'with params to create auction' do
      let(:params) { attributes_for(:auction, company: nil) }

      it 'creates auction only', :aggregate_failures do
        expect { call }.to change(Auction, :count).from(0).to(1)
        expect(call.data).to be_a(Auction)
        expect(call).to be_success
      end
    end

    context 'with params to add collaborators' do
      let(:params) do
        auction = attributes_for(:auction, company: nil)
        auction[:collaborator_ids] = [company_2.id]
        auction
      end

      it 'adds collaborator', :aggregate_failures do
        expect { call }.to change(Auction, :count).from(0).to(1).and(
          change(Collaborator, :count).from(0).to(1)
        )
        expect(call.data).to be_a(Auction)
        expect(call).to be_success
      end
    end

    context 'with unknown params' do
      let(:params) { { param: 'nil' } }

      it 'creates auction only', :aggregate_failures do
        expect { call }.not_to change(Auction, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
