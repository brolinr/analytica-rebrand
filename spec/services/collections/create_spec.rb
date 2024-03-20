# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collections::Create do
  subject(:call) { described_class.call(context: { company: company, lot: lot }) }

  let(:company) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company) }
  let(:lot) { create(:lot, auction: auction, collaborator: company) }

  describe '#call' do
    context 'with proper params' do
      it 'create collection', :aggregate_failures do
        expect { call }.to change(Collection, :count).from(0).to(1)
        expect(call.data).to be_a(Collection)
        expect(call).to be_success
      end
    end
  end
end
