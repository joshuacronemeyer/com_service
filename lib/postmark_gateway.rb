require 'net/http'
class PostmarkGateway

  MAIL_URL = "https://api.postmarkapp.com/email"

  def send_email(email:)
    uri = URI.parse(MAIL_URL)
    https = Net::HTTP.new(uri.host,uri.port)
    https.use_ssl = true
    req = Net::HTTP::Post.new(uri.path)
    req['content-type'] = "application/json"
    req['accept'] = "application/json"
    req['X-Postmark-Server-Token'] = "#{ENV["POSTMARK_KEY"]}"

    req.body = %{{
        "From": "#{email.from_name} #{email.from}",
        "To": "#{email.to_name} #{email.to}",
        "Subject": "#{email.subject}",
        "HtmlBody": "#{email.body}",
        "TextBody": "#{email.plain_text_body}",
        "MessageStream": "outbound"
    }}
    https.request(req)
  end
end
