# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lots::Destroy do
  subject(:call) { described_class.call(context: { lot: lot }) }

  let(:company) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company, starts_at: 2.days.ago, closes_at: 1.day.ago) }
  let(:lot) { create(:lot, collaborator: company, auction: auction) }

  describe '#call' do
    context 'with existing lot' do
      before { lot }

      it 'destroys lot', :aggregate_failures do
        expect { call }.to change(Lot, :count).from(1).to(0)
        expect(call.data).to be_a(Lot)
        expect(call).to be_success
      end
    end

    context 'with deleted lot' do
      before { lot.destroy! }

      it 'does not destroy anything', :aggregate_failures do
        expect { call }.not_to change(Lot, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
