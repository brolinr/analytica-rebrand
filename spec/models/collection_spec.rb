# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Collection do
  describe 'relations' do
    it { is_expected.to belong_to(:collectable) }
    it { is_expected.to belong_to(:company) }
  end
end
