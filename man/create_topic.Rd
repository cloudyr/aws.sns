\name{CreateTopic}
\alias{create_topic}
\title{Create a topic}
\description{Create an SNS topic}
\usage{
create_topic(name, ...)
}
\arguments{
  \item{name}{A character string containing a (private) name for the topic.}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{Create a new topic. The \code{name} is a private name for the topic. Use \code{\link{set_topic_attrs}} to set a publicly visible name for the topic.}
\value{If successful, a character string containing an SNS Topic ARN. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{\href{http://docs.aws.amazon.com/sns/latest/api/API_CreateTopic.html}{CreateTopic}}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{link{delete_topic}}
}
%\examples{}
