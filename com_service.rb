# frozen_string_literal: true

require 'sinatra'
require 'logger'

require_relative 'lib/email'
require_relative 'lib/email_provider'
require_relative 'lib/sendgrid_gateway'

set :logger, Logger.new($stdout)

post '/email' do
  request.body.rewind
  request_payload = ''
  begin
    request_payload = JSON.parse request.body.read
  rescue JSON::ParserError
    status 400
    return { error: 'Invalid request JSON' }.to_json
  end

  email = Email.new(
    to: request_payload['to'],
    to_name: request_payload['to_name'],
    from: request_payload['from'],
    from_name: request_payload['from_name'],
    subject: request_payload['subject'],
    body: request_payload['body']
  )

  if email.valid?
    EmailProvider.new.send_email(email: email, logger: logger)
  else
    status 400
    { error: 'All fields are required.' }.to_json
  end
end

error do
  status 500
  logger.error env['sinatra.error'].message
  { error: env['sinatra.error'].message }.to_json
end
