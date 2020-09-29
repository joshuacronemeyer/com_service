# Communications Service

This software was built as a demonstration of my programming skills. It showcases how I use OO principles to design a system, break down a problem into incremental tasks, and apply TDD to get rapid feedback and working software. [Jump to a description of the functionality](#an-http-service-that-accepts-post-requests-with-json-data-to-a-email)

Here is [a screencast - video still uploading. i'll link there soon](https://) of me building it in case you'd like to see the entire journey.

This software is an HTTP service providing an endpoint for sending email. It uses Sendgrid and Postmark to provide redundancy across communications service providers.

## How to install this service

This service can be deployed to heroku or run anywhere as a rack application with the following command.

`bundle exec rackup config.ru -p $PORT`

You will need to set a few environment variables for the software to work:

```
export EMAIL_SERVICE=sendgrid #use postmark if you want to switch
export POSTMARK_KEY=$postmark_api_key
export SENDGRID_KEY=$sendgrid_api_key
```

## Language and microframework choice/discussion

The problem specified that we should use a microframework to provide the HTTP interface for our service. I'm a Rails programmer so I chose Sinatra since it is very simple and is Ruby based. Using a microframework will let us focus on the domain and how I've chosen to model it.

## Trade­offs, omissions, todos

Time and communications were my biggest constraints on this project. Doing anything 'production ready' in just 3 hours means you don't have much time to spend on your decisions. I did my best to mitigate the time constraint by doing the simplest reasonable thing first. I call that building the 'thinnest possible end to end slice'. Communications was the other major constraint. Given no information about what consumers my API would have was a big problem. Is this service to be used by a mobile client where a user might need feedback about the validity of their inputs or is it to be used by internal systems generating automated emails? In the end my other constraint, time, informed everything. I built some basic validations and error responses to demonstrate my understanding, and to allow me to quickly get feedback from whoever the consumer of this service is.

Robust validation of the input is one big conversation that needs to happen. Error handling is a really important part of any service. Having clear and comprehensive handling of error conditions will improve quality and happiness from people who consume our API. Sendgrid and Postmark have very rich error responses and handle all the kinds of validation that our clients could want. I have implemented some basic error handling just to demonstrate I can build and test such things, but I want to have a clear understanding of who is consuming this service before I decide to pick a direction with creating a robust API.

Here are some tradeoffs/omissions/todos:

* TLDR; I didn't build email address validation. We should consider leveraging provider validation of the email and providing a consistent API across all providers.... THE FULL VERSION. Sendgrid/Postmark validate incoming email addresses and inputs for us. I'd like to map their validation messages back to a common error format so we don't have multiple layers of validation. Some scenarios i'm particularly leery of are situations where we consider an email address valid, but sendgrid/postmark considers it invalid. (Read the RFC. Email address validation is surprisingly complex... here is a wild one that is valid according to the RFC: phil.h\@\@ck@haacked.com) There are other things to consider as well. Postmark will return some error messages if an email address bounces, but not until the second request. This is the kind of error message we might want to return.
* HTML email stripping: A basic implementation is done. I want to get some sample emails so we can do more extensive testing of the plaintext stripping.
* It's using webrick. For production we'd want a different webserver.
* I was really keen to implement automatic failover, but had already hit my limit on the amount of time I could spend on this.

## Implementation Notes

Here are just some notes I made for myself while I was building the system. I left them here since they feature prominently in the YouTube video.

### an HTTP service that accepts POST requests with JSON data to a ‘/email’

Curl command to test with

```
curl "https://com-service.herokuapp.com/email" \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{
        "to": "fake@example.com",
        "to_name": "Ms. Fake",
        "from": "giosue_c@hotmail.com",
        "from_name": "Uber",
        "subject": "A Message from Uber",
        "body": "<h1>Your Bill</h1><p>$10</p>"
      }'
```

#### Features

* Do the appropriate validations on the input fields (NOTE: all fields are required).
* Convert the ‘body’ HTML to a plain text version to send along to the email provider. You can simply remove the HTML tags.
* Once the data has been processed and meets the validation requirements, it should send the email by making an HTTP request (don’t use SMTP) to one of the following two services: sendgrid, postmark

#### Optional Features - Which I haven't done... Yet

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
  -H "X-Postmark-Server-Token: <<apikey>>" \
  -d '{
        "From": "Josh Cronemeyer josh@laneone.com",
        "To": "Sender Person josh+test@laneone.com",
        "Subject": "Hello from Postmark",
        "HtmlBody": "<strong>Hello</strong> dear Postmark user.",
        "TextBody": "Hello dear Postmark user.",
        "MessageStream": "outbound"
      }'
```

