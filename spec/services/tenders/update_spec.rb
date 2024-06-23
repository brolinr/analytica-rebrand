# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tenders::Update do
  subject(:call) { described_class.call(context: { tender: tender }, params: params) }

  let(:administrator) { create(:administrator) }
  let(:tender) { create(:tender, administrator: administrator) }

  describe '#call' do
    context 'with permitted attributes' do
      let(:params) { { title: 'Updates title' } }

      it 'updates tender', :aggregate_failures do
        expect { call }.to change(tender, :title).to(params[:title])
        expect(call.data).to be_a(Tender)
        expect(call).to be_success
      end
    end

    context 'with unknown params' do
      let(:params) { { invalid: 'nil' } }

      it 'does not update tender', :aggregate_failures do
        expect { call }.not_to change { tender.reload.attributes }
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
