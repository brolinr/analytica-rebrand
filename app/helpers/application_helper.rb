# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  def full_title(page_title)
    page_title.blank? ? 'Analytica' : "Analytica | #{page_title} "
  end

  # rubocop:disable Metrics/ParameterLists
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def error_or_redirect(object:, success_path:, failure_path:, i18n_scope: nil,
                        success_string_key: nil, failure_string_key: nil, turbo_stream_response: nil)

    errors = nil
    if object.is_a?(Result)
      errors = []
      object.errors.each do |msg|
        errors << msg
      end
    end

    respond_to do |format|
      format.html do
        if object.instance_of?(TrueClass) || object.errors.empty?
          redirect_to(success_path,
                      flash: {
                        notice: errors.presence || nil ||
                                I18n.t(success_string_key) ||
                                I18n.t('success', scope: i18n_scope)
                      })
        else
          redirect_to(failure_path,
                      flash: {
                        error: errors.presence.join(', ') || nil ||
                               I18n.t(failure_string_key) ||
                               object.errors.full_messages
                      })
        end
      end
      format.turbo_stream do
        turbo_stream_response
      end
    end
  end
  # rubocop:enable Metrics/ParameterLists
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/PerceivedComplexity
end
