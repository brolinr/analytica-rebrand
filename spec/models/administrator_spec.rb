# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Administrator do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:email) }
  end

  describe 'factories' do
    let(:administrator) { create(:administrator) }

    it { expect { administrator }.to change(described_class, :count).by(1) }
  end
end
