# frozen_string_literal: true

require 'test_helper'

class CompanyOnboardingMailerTest < ActionMailer::TestCase
  test 'approve' do
    mail = CompanyOnboardingMailer.approve
    assert_equal 'Approve', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end

  test 'dissaprove' do
    mail = CompanyOnboardingMailer.dissaprove
    assert_equal 'Dissaprove', mail.subject
    assert_equal ['to@example.org'], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match 'Hi', mail.body.encoded
  end
end
