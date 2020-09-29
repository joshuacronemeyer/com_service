# frozen_string_literal: true

ENV['APP_ENV'] = 'test'
require_relative '../com_service'
require 'rack/test'
require 'minitest/autorun'
require 'webmock/minitest'

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
    ENV['EMAIL_SERVICE'] = 'sendgrid'
  end

  def test_we_handle_missing_body
    post '/email', ''

    assert_equal 400, last_response.status
  end

  def test_we_can_post_to_email
    stub_request(:post, SendgridGateway::MAIL_URL)
    params = {
      "to": 'fake@example.com',
      "to_name": 'Ms. Fake',
      "from": 'giosue_c@hotmail.com',
      "from_name": 'Uber',
      "subject": 'A Message from Uber',
      "body": '<h1>Your Bill</h1><p>$10</p>'
    }

    post '/email', params.to_json

    assert last_response.ok?
  end

  def test_missing_required_param_gets_400
    params = {
      "to_name": 'Ms. Fake',
      "from": 'giosue_c@hotmail.com',
      "from_name": 'Uber',
      "subject": 'A Message from Uber',
      "body": '<h1>Your Bill</h1><p>$10</p>'
    }

    post '/email', params.to_json

    assert_equal 400, last_response.status
    response = JSON.parse(last_response.body)
    assert_equal 'All fields are required.', response['error']
  end

  # TODO: Need to understand how to change to production mode or somehow force
  # our sinatra error handler to trigger so we can test..
  #
  # def test_sendgrid_500_raises
  #   stub_request(:post,  SendgridGateway::MAIL_URL).to_return(status: [500, "Internal Server Error"])
  #   params = {
  #     "to": "fake@example.com",
  #     "to_name": "Ms. Fake",
  #     "from": "giosue_c@hotmail.com",
  #     "from_name": "Uber",
  #     "subject": "A Message from Uber",
  #     "body": "<h1>Your Bill</h1><p>$10</p>"
  #   }
  #
  #   post '/email', params.to_json
  #
  #   assert_equal 500, last_response.status
  #   response = JSON.parse(last_response.body)
  #   assert_equal "Sendgrid responded with: code-500 : message-Internal Server Error : body-", response["error"]
  # end
end
