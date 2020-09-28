require 'sinatra'
require_relative 'email'

get '/' do
  'Hello world!'
end

post '/email' do

  email = Email.new(to: params["to"], to_name: params["to_name"], from: params["from"], from_name: params["from_name"], subject: params["subject"], body: params["body"])
  if email.valid?
    # SendgridGateway.new.send_email(email)
  else
    status 400
  end
  #use email params to create an email object
  #validate the email
  #if valid post to sendgrid
  #else return error messages

end

