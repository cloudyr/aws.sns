\name{subscribe}
\alias{subscribe}
\title{Subscribe to a topic}
\description{Subscribes an endpoint to the specified SNS topic.}
\usage{
subscribe(topic, endpoint, protocol, ...)
}
\arguments{
  \item{topic}{A character string containing an SNS Topic Amazon Resource Name (ARN).}
  \item{endpoint}{A character string containing the endpoint to be subscribed (e.g., an email address).}
  \item{protocol}{The allowed protocol types are: default, email, email-json, sqs, sms, http, https, and application.}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{Initiates a subscription of an endpoint to an SNS topic. For example, this is used to add an email address endpoint to a topic. Subscriptions need to be confirmed by the endpoint. For example, an SMS endpoint will require an SMS response to an subscription invitation message. Subscriptions can be removed using \code{\link{unsubscribe}} (or whatever method is described in the invitation message); thus subscriptions can be handled by both users and administrator (you).}
\value{If successful, a character string containing a subscription ARN. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/sns/latest/api/API_Subscribe.html}{Subscribe}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{unsubscribe}}
\code{\link{list_subscriptions}}
}
%\examples{}
