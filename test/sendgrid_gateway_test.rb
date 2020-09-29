ENV['APP_ENV'] = 'test'

require_relative '../lib/email'
require_relative '../lib/sendgrid_gateway'
require "minitest/autorun"
require 'webmock/minitest'

class SendgridGatewayTest < Minitest::Test
  def test_sendgrid_500_raises
    ENV["EMAIL_SERVICE"] = 'sendgrid'
    stub_request(:post,  SendgridGateway::MAIL_URL).to_return(status: [500, "Internal Server Error"])
    email = Email.new(to: "george@example.com", to_name: "George", from: "martha@example.com", from_name: "Martha", subject: "Let's go", body: "I want to go.")
    error = assert_raises RuntimeError do
      SendgridGateway.new.send_email(email: email)
    end
    assert_equal "Sendgrid responded with: code-500 : message-Internal Server Error : body-", error.message
  end
end

