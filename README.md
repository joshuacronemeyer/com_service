# Communications Service

## How to install this service

## Language and microframework choice/discussion

## Trade­offs, omissions, todos


## Implementation Notes

### an HTTP service that accepts POST requests with JSON data to a ‘/email’

Example Request Payload:

```
{
   “to”: “fake@example.com”,
   “to_name”: “Ms. Fake”,
   “from”: “noreply@uber.com”,
   “from_name”: “Uber”,
   “subject”: “A Message from Uber”,
   “body”: “<h1>Your Bill</h1><p>$10</p>”
}
```

#### Features

* Do the appropriate validations on the input fields (NOTE: all fields are required).
* Convert the ‘body’ HTML to a plain text version to send along to the email provider. You can simply remove the HTML tags.
* Once the data has been processed and meets the validation requirements, it should send the email by making an HTTP request (don’t use SMTP) to one of the following two services: sendgrid, postmark

### TODOS

* Go back and drive out the validations for emails
* Send HTML email body with plaintext backup
* Get some sample emails we can do more extensive testing of the plaintext stripping.

### QUESTIONS

* how to handle validation error messages

#### Optional Features

* Instead of relying on a configuration change for choosing which email provider to use, dynamically select a provider based on their error responses. For instance, if Sendgrid started to timeout or was returning errors, automatically switch to Postmark.
* Keep a record of emails passing through your service in some queryable form of data storage.
* Both Sendgrid and Postmark have webhooks for email opens and clicks. Implement endpoints on your service to receive those webhook POST requests and store that information in some form of data storage.
* Both services offer delayed delivery. Implement a delivery date / time parameter for POST requests to your service.


### Sendgrid

```
curl -v --request POST \
--url https://api.sendgrid.com/v3/mail/send \
--header 'authorization: Bearer <<api key>> \
--header 'content-type: application/json' \
--data '{"personalizations":[{"to":[{"email":"joshuacronemeyer@gmail.com","name":"Joshy Poo"}],"subject":"Hello, World!"}],"content": [{"type": "text/plain", "value": "Heya!"}],"from":{"email":"giosue_c@hotmail.com","name":"Joshy"},"reply_to":{"email":"giosue_c@hotmail.com","name":"Josh"}}'
```

### Postmark

```
curl "https://api.postmarkapp.com/email" \
  -X POST \
  -H "Accept: application/json" \
  -H "Content-Type: application/json" \
  -H "X-Postmark-Server-Token: server token" \
  -d '{
  "From": "sender@example.com",
  "To": "receiver@example.com",
  "Subject": "Postmark test",
  "TextBody": "Hello dear Postmark user.",
  "HtmlBody": "<html><body><strong>Hello</strong> dear Postmark user.</body></html>",
  "MessageStream": "outbound"
}'
```

