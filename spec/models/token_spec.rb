# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Token do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:purpose) }
    it { is_expected.to validate_presence_of(:status) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:generator) }
  end

  describe 'factories' do
    let(:token) { create(:token) }

    it { expect { token }.to change(described_class, :count).by(1) }
  end
end
