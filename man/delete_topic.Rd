\name{DeleteTopic}
\alias{delete_topic}
\title{Delete a topic}
\description{Delete an SNS topic}
\usage{
delete_topic(topic, ...)
}
\arguments{
  \item{topic}{A character string containing an SNS Topic Amazon Resource Name (ARN).}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{Delete an existing topic.}
\value{If successful, a logical \code{TRUE}. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/sns/latest/api/API_CreateTopic.html}{CreateTopic}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{create_topic}}
}
%\examples{}
