# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collaborator do
  let(:collaborator) { create(:collaborator) }
  describe 'relations' do
    it { is_expected.to belong_to(:company) }
    it { is_expected.to belong_to(:auction) }
   # TODO: SHOuld have many lots
  end

  describe 'validations' do
    pending "validates uniqueness of company_id scoped to auction_id" do
      existing_collaborator = FactoryBot.create(:collaborator)
      expect(existing_collaborator).to validate_uniqueness_of(:company_id).scoped_to(:auction_id)
    end
  end

  describe 'factories' do
    context 'company should be confirmed' do
      describe 'factories' do
        it { expect { collaborator }.to change(described_class, :count).by(1) }
        it { expect { collaborator }.to change(described_class, :count).by(1) }
      end
    end
  end
end