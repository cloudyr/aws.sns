\name{unsubscribe}
\alias{unsubscribe}
\title{Unsubscribe from a topic}
\description{Cancels an endpoint's subscription to a topic.}
\usage{
unsubscribe(subscription, ...)
}
\arguments{
  \item{subscription}{A character string containing an SNS Subscription Amazon Resource Name (ARN).}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{Unsubscribes an endpoint from an SNS topic.}
\value{If successful, a logical \code{TRUE}. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/sns/latest/api/API_Unsubscribe.html}{Unsubscribe}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{unsubscribe}}
\code{\link{list_subscriptions}}
}
%\examples{}
