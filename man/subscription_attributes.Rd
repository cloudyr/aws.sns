\name{Subscription Attributes}
\alias{get_subscription_attrs}
\alias{set_subscription_attrs}
\title{Get/set subscription attributes}
\description{Get or set subscription attributes}
\usage{
get_subscription_attrs(subscription, ...)

set_subscription_attrs(subscription, attribute, ...)
}
\arguments{
  \item{subscription}{A character string containing an SNS Subscription Amazon Resource Name (ARN).}
  \item{attribute}{A named, single-element list containing a subscription attribute. Name must be either \dQuote{DeliveryPolicy} or \dQuote{RawMessageDelivery}.}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{\code{get_subscription_attrs} retrieves subscription attributes, while \code{set_subscription_attrs} can be used to set those attributes.}
\value{If successful, for \code{get_subscription_attrs}: a named list containing some details of the request, for \code{set_subscription_attrs}: a logical \code{TRUE} value. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{
\href{http://docs.aws.amazon.com/sns/latest/api/API_GetSubscriptionAttributes.html}{GetSubscriptionAttributes}
\href{http://docs.aws.amazon.com/sns/latest/api/API_SetSubscriptionAttributes.html}{SetSubscriptionAttributes}
}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{subscribe}}
\code{link{unsubscribe}}
\code{link{list_subscriptions}}
}
%\examples{}
