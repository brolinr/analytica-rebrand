# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lots::Create do
  subject(:call) { described_class.call(context: { company: company, auction: auction }, params: params) }

  let(:company) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company) }

  describe '#call' do
    context 'with correct params' do
      let(:params) { attributes_for(:lot, collaborator: nil) }

      it 'creates lot' do
        expect { call }.to change(Lot, :count).from(0).to(1)
        expect(call.data).to be_a(Lot)
        expect(call).to be_success
      end
    end

    context 'with unknown params' do
      let(:params) { { invalid: 'nil' } }

      it 'does not creates lot' do
        expect { call }.not_to change(Lot, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
