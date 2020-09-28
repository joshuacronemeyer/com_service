ENV['APP_ENV'] = 'test'

require_relative '../com_service'
require 'rack/test'
require "minitest/autorun"

class HelloWorldTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  # def test_it_says_hello_world
  #   get '/'
  #   assert last_response.ok?
  #   assert_equal 'Hello World!', last_response.body
  # end

  def test_we_can_post_to_email
    params = {
      "to": "fake@example.com",
      "to_name": "Ms. Fake",
      "from": "giosue_c@hotmail.com",
      "from_name": "Uber",
      "subject": "A Message from Uber",
      "body": "<h1>Your Bill</h1><p>$10</p>"
    }

    post '/email', params

    assert last_response.ok?
  end

  def test_missing_required_param_gets_400

    params = {
      "to_name": "Ms. Fake",
      "from": "giosue_c@hotmail.com",
      "from_name": "Uber",
      "subject": "A Message from Uber",
      "body": "<h1>Your Bill</h1><p>$10</p>"
    }

    post '/email', params

    assert_equal 400, last_response.status
  end
end
