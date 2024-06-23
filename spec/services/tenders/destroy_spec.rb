# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tenders::Destroy do
  subject(:call) { described_class.call(context: { tender: tender }) }

  let(:administrator) { create(:administrator) }
  let(:tender) { create(:tender, administrator: administrator) }

  describe '#call' do
    context 'with existing tender' do
      before { tender }

      it 'destroys tender', :aggregate_failures do
        expect { call }.to change(Tender, :count).from(1).to(0)
        expect(call.data).to be_a(Tender)
        expect(call).to be_success
      end
    end

    context 'with already deletes tender' do
      before { tender.destroy }

      it 'does not delete anything', :aggregate_failures do
        expect { call }.not_to change(Tender, :count).from(0)
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
