# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collections::Destroy do
  subject(:call) { described_class.call(context: { collection: collection }) }

  let!(:company) { create(:company, :as_supplier) }
  let!(:auction) { create(:auction, company: company) }
  let!(:lot) { create(:lot, auction: auction, collaborator: company) }
  let(:collection) { create(:collection, collectable: lot, company: company) }

  describe '#call' do
    context 'with existing collection' do
      before { collection }

      it 'destroys collection', :aggregate_failures do
        expect { call }.to change(Collection, :count).from(1).to(0)
        expect(call.data).to be_a(Collection)
        expect(call).to be_success
      end
    end

    context 'with already deletes collection' do
      before { collection.destroy }

      it 'does not delete anything', :aggregate_failures do
        expect { call }.not_to change(Collection, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
