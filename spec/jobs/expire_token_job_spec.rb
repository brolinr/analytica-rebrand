# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExpireTokenJob do
  subject(:perform) { described_class.new.perform(token.id) }

  let!(:token) { create(:token, status: :active) }

  describe '#perform' do
    context 'when token is valid' do
      it 'expires the token', :aggregate_failures do
        expect(Token.count).to eq(1)
        expect { perform }.to change { token.reload.status }.from('active').to('void')
      end
    end
  end
end
