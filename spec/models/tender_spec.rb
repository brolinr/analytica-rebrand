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
end