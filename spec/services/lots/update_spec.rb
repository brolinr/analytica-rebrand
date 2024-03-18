# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Lots::Update do
  subject(:call) { described_class.call(context: { lot: lot }, params: params) }

  let(:company) { create(:company, :as_supplier) }
  let(:auction) { create(:auction, company: company, starts_at: 2.days.ago, closes_at: 1.day.ago) }
  let(:lot) { create(:lot, collaborator: company, auction: auction) }

  describe '#call' do
    context 'with permitted attributes' do
      let(:params) { { title: 'Updates title' } }

      it 'updates lot', :aggregate_failures do
        expect { call }.to change(lot, :title).to(params[:title])
        expect(call.data).to be_a(Lot)
        expect(call).to be_success
      end
    end

    context 'with unknown params' do
      let(:params) { { invalid: 'nil' } }

      it 'does not update lot', :aggregate_failures do
        expect { call }.not_to change { lot.reload.attributes }
        expect(call.errors).not_to be_empty
        expect(call).to be_failure
      end
    end
  end
end
