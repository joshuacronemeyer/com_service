# frozen_string_literal: true

require_relative '../lib/email'
require_relative '../lib/postmark_gateway'
require 'minitest/autorun'
require 'webmock/minitest'

class PostmarkGatewayTest < Minitest::Test
  def test_postmark_500_raises
    stub_request(:post, PostmarkGateway::MAIL_URL).to_return(status: [500, 'Internal Server Error'])
    email = Email.new(to: 'george@example.com', to_name: 'George', from: 'martha@example.com', from_name: 'Martha', subject: "Let's go", body: 'I want to go.')
    error = assert_raises RuntimeError do
      PostmarkGateway.new.send_email(email: email)
    end
    assert_equal 'Postmark responded with: code-500 : message-Internal Server Error : body-', error.message
  end

  def test_json_to_postmark_contains_all_our_great_data
    stub_request(:post, PostmarkGateway::MAIL_URL)
    email = Email.new(to: 'george@example.com', to_name: 'George', from: 'martha@example.com', from_name: 'Martha', subject: "Let's go", body: 'I want to go.')
    PostmarkGateway.new.send_email(email: email)
    assert_requested :post, PostmarkGateway::MAIL_URL, body: /george@example.com/
    assert_requested :post, PostmarkGateway::MAIL_URL, body: /martha@example.com/
    assert_requested :post, PostmarkGateway::MAIL_URL, body: /George/
    assert_requested :post, PostmarkGateway::MAIL_URL, body: /Martha/
    assert_requested :post, PostmarkGateway::MAIL_URL, body: /Let's go/
    assert_requested :post, PostmarkGateway::MAIL_URL, body: /I want to go/
  end
end
