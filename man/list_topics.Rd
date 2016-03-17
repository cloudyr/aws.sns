\name{list_topics}
\alias{list_topics}
\title{List subscriptions for a topic}
\description{Lists subscriptions for a specified topic}
\usage{
list_topics(token, ...)
}
\arguments{
  \item{token}{A paging paramter used to return additional pages of results. This will be available in the \dQuote{NextToken} attribute of a previous call to \code{list_topics}.}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{Lists topics. Up to 100 subscriptions are returned by each request. The \code{token} argument can be used to return additional results.}
\value{If successful, a dataframe containing details of . Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/sns/latest/api/API_ListTopics.html}{ListTopics}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{subscribe}}
\code{link{unsubscribe}}
\code{link{get_subscription_attrs}}
}
%\examples{}
