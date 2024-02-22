# frozen_string_literal: true

class ReverseAuction::ApplicationController < ApplicationController
  before_action :authenticate_company!

  layout 'reverse_auction'
end
