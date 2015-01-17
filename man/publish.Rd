\name{publish}
\alias{publish}
\title{Execute SNS API Request}
\description{This is the workhorse function to execute calls to the SNS API.}
\usage{
publish(topic, target, message, subject, ...)
}
\arguments{
  \item{topic}{Optionally, a character string containing an SNS Topic Amazon Resource Name (ARN). Must specify \code{topic} or \code{target}.}
  \item{target}{Optionally, a character string containing an SNS Target ARN. Must specify \code{topic} or \code{target}.}
  \item{message}{Either a single character string containing a message to be sent to all endpoints, or a named list of messages to be sent to specific endpoints (where the names of each element correspond to endpoints).}
  \item{subject}{Optionally, a character string containing a subject line (e.g., to be used for an email endpoint).}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{Publishes a message to a topic, or a target. Messages can be the same for all endpoints or customized so that, for example, a short 140-character message is sent to SMS endpoints that are subscribed to a topic while longer messages are sent to email endpoints, etc. The allowed message types are: default, email, email-json, sqs, sms, http, https, and application.}
\value{If successful, a named list containing some details of the request. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/sns/latest/api/API_Publish.html}{Publish}}
\author{Thomas J. Leeper}
%\note{}
%\seealso{}
%\examples{}
