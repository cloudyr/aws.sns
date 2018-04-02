# AWS SNS Client Package

**aws.sns** is a simple client package for the Amazon Web Services (AWS) [Simple Notification Service (SNS)](https://aws.amazon.com/sns/) API, which can be used to trigger push messages to a variety of users, devices, and other endpoints. This might be useful for maintaining multi-platform mailing lists, or simply for creating a way to notify yourself when long-running code completes.

To use the package, you will need an AWS account and to enter your credentials into R. Your keypair can be generated on the [IAM Management Console](https://aws.amazon.com/) under the heading *Access Keys*. Note that you only have access to your secret key once. After it is generated, you need to save it in a secure location. New keypairs can be generated at any time if yours has been lost, stolen, or forgotten. The [**aws.iam** package](https://github.com/cloudyr/aws.iam) profiles tools for working with IAM, including creating roles, users, groups, and credentials programmatically; it is not needed to *use* IAM credentials.

By default, all **cloudyr** packages for AWS services allow the use of credentials specified in a number of ways, beginning with:

 1. User-supplied values passed directly to functions.
 2. Environment variables, which can alternatively be set on the command line prior to starting R or via an `Renviron.site` or `.Renviron` file, which are used to set environment variables in R during startup (see `? Startup`). Or they can be set within R:
 
    ```R
    Sys.setenv("AWS_ACCESS_KEY_ID" = "mykey",
               "AWS_SECRET_ACCESS_KEY" = "mysecretkey",
               "AWS_DEFAULT_REGION" = "us-east-1",
               "AWS_SESSION_TOKEN" = "mytoken")
    ```
 3. If R is running an EC2 instance, the role profile credentials provided by [**aws.ec2metadata**](https://cran.r-project.org/package=aws.ec2metadata).
 4. Profiles saved in a `/.aws/credentials` "dot file" in the current working directory. The `"default" profile is assumed if none is specified.
 5. [A centralized `~/.aws/credentials` file](https://blogs.aws.amazon.com/security/post/Tx3D6U6WSFGOK2H/A-New-and-Standardized-Way-to-Manage-Credentials-in-the-AWS-SDKs), containing credentials for multiple accounts. The `"default" profile is assumed if none is specified.

Profiles stored locally or in a centralized location (e.g., `~/.aws/credentials`) can also be invoked via:

```R
# use your 'default' account credentials
aws.signature::use_credentials()

# use an alternative credentials profile
aws.signature::use_credentials(profile = "bob")
```

Temporary session tokens are stored in environment variable `AWS_SESSION_TOKEN` (and will be stored there by the `use_credentials()` function). The [aws.iam package](https://github.com/cloudyr/aws.iam/) provides an R interface to IAM roles and the generation of temporary session tokens via the security token service (STS).


## Code Examples

The main purpose of Amazon SNS is to be able to push messages to different endpoints (e.g., Email, SMS, a Simple Queue Service queue, etc.). To do this, you have to create a *topic*, *subscribe* different endpoints (e.g., user email addresses) to that topic, and then *publish* to the topic. You can subscribe different types of endpoints to the same topic and, similarly, publish different messages to each type of endpoint simultaneously.

To create a topic, use `create_topic` and configure it using `set_topic_attrs`. The `name` argument in `create_topic` is a private label for you to keep track of topics. To use a topic, you need to use `set_topic_attrs` to configure a public display name that will be visible to subscribers:


```r
library("aws.sns")
topic <- create_topic(name = "TestTopic")
set_topic_attrs(topic, attribute = c(DisplayName = "Publicly visible topic name"))
```

```
## [1] TRUE
## attr(,"RequestId")
## [1] "f89a12da-baa7-50d6-a9fa-430ad53ffca7"
```

To add a subscription to a topic:


```r
subscribe(topic, "me@example.com", "email")
```

```
## [1] "pending confirmation"
## attr(,"RequestId")
## [1] "5ef5d1d0-6291-5fe1-bd95-80000d095390"
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
## [1] "f4150164-b522-592f-ac6f-50b4dabbb55e"
## attr(,"RequestId")
## [1] "b94b8a69-66e1-55ed-b786-dbb90978399c"
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
## [1] "ff5300ee-8440-5611-9cd2-513eebd9ba60"
## attr(,"RequestId")
## [1] "460f2808-ea90-5d67-92eb-79d885095116"
```

In addition to the standard endpoints ("http", "https", "email", "email-json", "sms", "sqs", "application"), it is possible to create endpoints for mobile platform applications. [See the SNS Developer Guide for further details](http://docs.aws.amazon.com/sns/latest/dg/SNSMobilePush.html).

It is also possible to give other AWS accounts permission to view or publish to a topic using `add_permission`. For example, you may want to have multiple administrators who share responsibility for publishing messages to the topic. Permissions can be revoked using `remove_permission`.

## Installation

[![CRAN](https://www.r-pkg.org/badges/version/aws.sns)](https://cran.r-project.org/package=aws.sns)
![Downloads](https://cranlogs.r-pkg.org/badges/aws.sns)
[![Travis Build Status](https://travis-ci.org/cloudyr/aws.sns.png?branch=master)](https://travis-ci.org/cloudyr/aws.sns) 
[![codecov.io](https://codecov.io/github/cloudyr/aws.sns/coverage.svg?branch=master)](https://codecov.io/github/cloudyr/aws.sns?branch=master)

This package is not yet on CRAN. To install the latest development version you can install from the cloudyr drat repository:

```R
# latest stable version
install.packages("aws.sns", repos = c(cloudyr = "http://cloudyr.github.io/drat", getOption("repos")))
```

Or, to pull a potentially unstable version directly from GitHub:

```R
if(!require("remotes")){
    install.packages("remotes")
}
remotes::install_github("cloudyr/aws.sns")
```

---
[![cloudyr project logo](http://i.imgur.com/JHS98Y7.png)](https://github.com/cloudyr)
