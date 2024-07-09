# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Tenders::Create do
  subject(:call) { described_class.call(context: { administrator: administrator }, params: params) }

  let(:administrator) { create(:administrator) }

  describe '#call' do
    context 'with proper params' do
      let(:params) { attributes_for(:tender, administrator: nil) }

      it 'create collection', :aggregate_failures do
        expect { call }.to change(Tender, :count).from(0).to(1)
        expect(call.data).to be_a(Tender)
        expect(call).to be_success
      end
    end
  end
end
