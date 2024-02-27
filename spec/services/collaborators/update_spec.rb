require 'rails_helper'

RSpec.describe Collaborators::Update do
  subject(:call) { described_class.call(context: { collaborator: collaborator }, params: params) }

  describe '#call' do
    context 'with params to accepting a request ' do
      it 'accepts a request', :aggregate_failures do
        expect { call }.to change { collaborator.reload.acceptance_status }.from('pending').to('accepted')
      end
    end

    context 'with params to decline a request' do
      it 'declines a request a request', :aggregate_failures do
        expect { call }.to change { collaborator.reload.acceptance_status }.from('pending').to('declined')
      end
    end

    context 'when the auction is expired' do
      it 'The collaboration request is destroyed' do
        expect { call }.to change(Collaborator, :count).from(0).to(1)
      end
    end
  end
end