# frozen_string_literal: true

require 'test_helper'

class ReverseAuctions::CollectionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get reverse_auctions_collections_index_url
    assert_response :success
  end
end
