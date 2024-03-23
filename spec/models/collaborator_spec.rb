# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collaborator do
  let(:collaborator) { create(:collaborator) }

  describe 'relations' do
    it { is_expected.to have_many(:lots).dependent(:nullify) }
    it { is_expected.to belong_to(:collaborator) }
    it { is_expected.to belong_to(:auction) }
  end

  describe 'factories' do
    it { expect { collaborator }.to change(described_class, :count).by(1) }
  end
end
