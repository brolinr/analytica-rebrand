require 'rails_helper'

RSpec.describe Tag do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
  end

  describe 'relations' do
    it { is_expected.to belong_to(:taggable).required(false) }
  end
end
