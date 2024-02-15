# frozen_string_literal: true

class ExpireTokenJob
  include Sidekiq::Job

  def perform(token_id)
    @token = Token.find(token_id)
    @token.void!
  rescue ActiveRecord::RecordNotFound
    sidekiq_options retry: false
  end
end
