# frozen_string_literal: true

class ExpireTokenJob
  include Sidekiq::Job

  def perform(token_id)
    @token = Token.find(token_id)
    @token.void!
  rescue StandardError
    sidekiq_options_hash retry: false
  end
end
