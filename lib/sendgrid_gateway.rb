require 'net/http'

class SendgridGateway

  MAIL_URL = "https://api.sendgrid.com/v3/mail/send"

  def send_email(email:)
    uri = URI.parse(MAIL_URL)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    sendgrid_key = ENV["SENDGRID_KEY"]
    raise "SENDGRID_KEY must be configured" if sendgrid_key.nil? || sendgrid_key == ""
    req['authorization'] = "Bearer #{sendgrid_key}"
    req['content-type'] = "application/json"
    req.body = %{{"personalizations":[{"to":[{"email":"#{email.to}","name":"#{email.to_name}"}],"subject":"#{email.subject}"}],"content": [ {"type": "text/plain", "value": "#{email.plain_text_body}"}, {"type": "text/html", "value": "#{email.body}"}],"from":{"email":"#{email.from}","name":"#{email.from_name}"}}}
    response = https.request(req)

    if response.code.to_i >= 500
      raise "Sendgrid responded with: code-#{response.code} : message-#{response.message} : body-#{response.body}"
    end
  end
end
