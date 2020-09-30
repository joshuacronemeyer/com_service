# frozen_string_literal: true

require 'net/http'

# Understands how to talk to postmark
class PostmarkGateway
  MAIL_URL = 'https://api.postmarkapp.com/email'

  def send_email(email:)
    uri = URI.parse(MAIL_URL)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req['content-type'] = 'application/json'
    req['accept'] = 'application/json'
    req['X-Postmark-Server-Token'] = ensure_postmark_configuration

    req.body = postmark_email_json(email: email)
    response = https.request(req)
    handle_500(response: response)
  end

  private

  def postmark_email_json(email:)
    %({
        "From": "#{email.from_name} #{email.from}",
        "To": "#{email.to_name} #{email.to}",
        "Subject": "#{email.subject}",
        "HtmlBody": "#{email.body}",
        "TextBody": "#{email.plain_text_body}",
        "MessageStream": "outbound"
    })
  end

  def ensure_postmark_configuration
    postmark_key = ENV['POSTMARK_KEY']
    raise 'POSTMARK_KEY must be configured' if postmark_key.nil? || postmark_key == ''

    postmark_key
  end

  def handle_500(response:)
    return unless response.code.to_i >= 500

    raise "Postmark responded with: code-#{response.code} : message-#{response.message} : body-#{response.body}"
  end
end
