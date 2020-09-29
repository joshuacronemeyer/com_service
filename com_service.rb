require 'sinatra'
require_relative 'lib/email'
require_relative 'lib/sendgrid_gateway'

post '/email' do

  email = Email.new(to: params["to"], to_name: params["to_name"], from: params["from"], from_name: params["from_name"], subject: params["subject"], body: params["body"])
  if email.valid?
    EmailProvider.new.send_email(email: email)
  else
    status 400
  end

end

