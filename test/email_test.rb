ENV['APP_ENV'] = 'test'

require_relative '../email'
require "minitest/autorun"

class EmailTest < Minitest::Test

  def setup
    @email = Email.new(to: "george@example.com", to_name: "George", from: "martha@example.com", from_name: "Martha", subject: "Let's go", body: "I want to go.")
  end

  def test_to_is_required
    @email.to = nil
    assert_equal false, @email.valid?
  end

  def test_we_strip_tags_from_plain_text_body
    @email.body = "<h1>Hello World!</h1>"
    assert_equal "Hello World!", @email.plain_text_body
  end
  def test_we_strip_tags_from_plain_text_body_with_newline
    @email.body = "<h1>Hello World!</h1>\n<p>with a paragraph</p>"
    assert_equal "Hello World!\nwith a paragraph", @email.plain_text_body
  end
end
