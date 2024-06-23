require 'rails_helper'

RSpec.describe Tender do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:deadline) }
    it { is_expected.to validate_presence_of(:location) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:tags).dependent(:nullify) }
  end

  describe 'factories' do
    let(:administrator) { create(:administrator) }
    let(:tender) { create(:tender, administrator: administrator) }

    it { expect { tender }.to change(described_class, :count).by(1) }
  end
end
