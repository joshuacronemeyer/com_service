
require_relative '../lib/email_provider'
require_relative '../lib/email'
require "minitest/autorun"
require 'webmock/minitest'

class EmailProviderTest < Minitest::Test

  def test_unconfigured_provider_raises_error
    ENV["EMAIL_SERVICE"] = nil
    error = assert_raises RuntimeError do
      EmailProvider.new.send_email(email:nil)
    end

    assert_match(/Email service must be/, error.message)
  end

  def test_invalid_provider_raises_error
    ENV["EMAIL_SERVICE"] = 'mailchimp'
    error = assert_raises RuntimeError do
      EmailProvider.new.send_email(email:nil)
    end

    assert_match(/Email service must be/, error.message)
  end

  def test_we_can_configure_postmark
    stub_request(:post,  PostmarkGateway::MAIL_URL)
    email = Email.new(to: "josh+test@laneone.com", to_name: "George", from: "josh@laneone.com", from_name: "Martha", subject: "Let's go", body: "I want to go.")
    ENV["EMAIL_SERVICE"] = 'postmark'
    EmailProvider.new.send_email(email:email)
    assert_requested :post, PostmarkGateway::MAIL_URL, times: 1
  end

  def test_we_can_configure_sendgrid
    stub_request(:post,  SendgridGateway::MAIL_URL)
    email = Email.new(to: "george@example.com", to_name: "George", from: "martha@example.com", from_name: "Martha", subject: "Let's go", body: "I want to go.")
    ENV["EMAIL_SERVICE"] = 'sendgrid'
    EmailProvider.new.send_email(email: email)
    assert_requested :post, SendgridGateway::MAIL_URL, times: 1
  end

end

