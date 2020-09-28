ENV['APP_ENV'] = 'test'

require_relative 'email'
require "minitest/autorun"

class EmailTest < Minitest::Test
  def test_to_is_required
    email = Email.new(to: nil, to_name: "George", from: "martha@example.com", from_name: "Martha", subject: "Let's go", body: "I want to go.")
    assert_equal false, email.valid?
  end
end
