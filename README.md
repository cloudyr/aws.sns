# AWS SNS Client Package #

**aws.sns** is a simple client package for the Amazon Web Services (AWS) [Simple Notification Service (SNS)](http://aws.amazon.com/sns/) API, which can be used to trigger push messages to a variety of users, devices, and other endpoints. This might be useful for maintaining multi-platform mailing lists, or simply for creating a way to notify yourself when long-running code completes.

## Code Examples ##

The main purpose of Amazon SNS is to be able to push messages to different endpoints (e.g., Email, SMS, a Simple Queue Service queue, etc.). To do this, you have to create a *topic*, *subscribe* different endpoints (e.g., user email addresses) to that topic, and then *publish* to the topic. You can subscribe different types of endpoints to the same topic and, similarly, publish different messages to each type of endpoint simultaneously.

To create a topic, use `create_topic` and configure it using `set_topic_attrs`. The `name` argument in `create_topic` is a private label for you to keep track of topics. To use a topic, you need to use `set_topic_attrs` to configure a public display name that will be visible to subscribers:


```r
library("aws.sns")
topic <- create_topic(name = "TestTopic")
set_topic_attrs(topic, attribute = c(DisplayName = "Publicly visible topic name"))
```

```
## list()
## attr(,"RequestId")
## [1] "4e055b41-adb6-5859-b6d1-167545652e16"
```

To add a subscription to a topic:


```r
subscribe(topic, "me@example.com", "email")
```

```
## [1] "pending confirmation"
## attr(,"RequestId")
## [1] "83af083b-0bc0-5654-b443-450fe313e0b3"
```

```r
#subscribe(topic, "1-111-555-1234", "sms") # SMS example
```

You can confirm the status of subscriptions using `list_subscriptions`:


```r
list_subscriptions(topic)
```

```
##         Endpoint        Owner Protocol     SubscriptionArn
## 1 me@example.com 920667304251    email PendingConfirmation
##                                       TopicArn
## 1 arn:aws:sns:us-east-1:920667304251:TestTopic
```

Subscriptions need to be confirmed by the endpoint. For example, an SMS endpoint will require an SMS response to an subscription invitation message. Subscriptions can be removed using `unsubscribe` (or whatever method is described in the invitation message); thus subscriptions can be handled by both users and administrator (you).

The endpoint will then receive a confirmation message, like the following, to confirm the subscription:

![Email confirmation message](http://i.imgur.com/8EK6jBu.png)

If they accept the invitation, the user will receive a confirmation of their subscription:

![Subscription confirmation screen](http://i.imgur.com/cK1KU3C.png)


To publish a message, use `publish`:


```r
publish(topic = topic, message = "This is a test message!", subject = "Hello!")
```

```
## [1] "daec96f6-7e09-57bc-9533-dbc296ddc02c"
## attr(,"RequestId")
## [1] "9bcca33f-0a57-5b40-94d0-ee0be2830cd0"
```

By default, the message is sent to all platforms:

![Example message](http://i.imgur.com/nglMtZ9.png)


This may not be ideal if multiple dissimilar endpoints are subscribed to the same topic (e.g., SMS and email). This can be resolved by maintaining separate Topics or, more easily, by sending different messages to each type of endpoint:


```r
msgs <- list()
msgs$default = "This is the default message." # required
msgs$email = "This is a test email that will be sent to email addresses only."
msgs$sms = "This is a test SMS that will be sent to phone numbers only."
msgs$http = "This is a test message that will be sent to http URLs only."
publish(topic = topic, message = msgs, subject = "Hello!")
```

```
## [1] "bc5f4554-b40d-585b-9a9f-08605cd92871"
## attr(,"RequestId")
## [1] "509bfe4e-68e5-5870-b930-b37a8031885a"
```

In addition to the standard endpoints ("http", "https", "email", "email-json", "sms", "sqs", "application"), it is possible to create endpoints for mobile platform applications. [See the SNS Developer Guide for further details](http://docs.aws.amazon.com/sns/latest/dg/SNSMobilePush.html).

It is also possible to give other AWS accounts permission to view or publish to a topic using `add_permission`. For example, you may want to have multiple administrators who share responsibility for publishing messages to the topic. Permissions can be revoked using `remove_permission`.

## Installation ##

[![CRAN](http://www.r-pkg.org/badges/version/aws.sns)](http://cran.r-project.org/package=aws.sns)
[![Travis Build Status](https://travis-ci.org/cloudyr/aws.sns.png?branch=master)](https://travis-ci.org/cloudyr/aws.sns) 
[![codecov.io](http://codecov.io/github/cloudyr/aws.sns/coverage.svg?branch=master)](http://codecov.io/github/cloudyr/aws.sns?branch=master)

To install the latest development version from GitHub, run the following:

```R
if(!require("ghit")){
    install.packages("ghit")
}
ghit::install_github("cloudyr/aws.sns")
```

To install the latest version from CRAN, simply use `install.packages("aws.sns")`.

---
[![cloudyr project logo](http://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
