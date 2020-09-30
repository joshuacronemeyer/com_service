# frozen_string_literal: true

require 'net/http'

# Understands how to talk to sendgrid
class SendgridGateway
  MAIL_URL = 'https://api.sendgrid.com/v3/mail/send'

  def send_email(email:)
    uri = URI.parse(MAIL_URL)
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)

    req['authorization'] = "Bearer #{ensure_sendgrid_configuration}"
    req['content-type'] = 'application/json'
    req.body = sendgrid_email_json(email: email)
    response = https.request(req)
    handle_500(response: response)
    handle_400(response: response)
  end

  private

  def ensure_sendgrid_configuration
    sendgrid_key = ENV['SENDGRID_KEY']
    raise 'SENDGRID_KEY must be configured' if sendgrid_key.nil? || sendgrid_key == ''

    sendgrid_key
  end

  def sendgrid_email_json(email:)
    {
      "personalizations":
        [{ "to": [{ "email": email.to, "name": email.to_name }], "subject": email.subject }],
      "content":
        [{ "type": 'text/plain', "value": email.plain_text_body }, { "type": 'text/html', "value": email.body }],
      "from":
        { "email": email.from, "name": email.from_name }
    }.to_json
  end

  def handle_500(response:)
    return unless response.code.to_i >= 500

    raise "Sendgrid responded with: code-#{response.code} : message-#{response.message} : body-#{response.body}"
  end

  def handle_400(response:)
    return unless response.code.to_i >= 400 && response.code.to_i <= 499

    raise "Sendgrid responded with: code-#{response.code} : message-#{response.message} : body-#{response.body}"
  end
end
