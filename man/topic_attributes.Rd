\name{Topic Attributes}
\alias{get_topic_attrs}
\alias{set_topic_attrs}
\title{Get/set topic attributes}
\description{Get or set topic attributes}
\usage{
get_topic_attrs(topic, ...)

set_topic_attrs(topic, attribute, ...)
}
\arguments{
  \item{topic}{A character string containing an SNS Topic Amazon Resource Name (ARN).}
  \item{attribute}{A named, single-element list containing a topic attribute. Name must be either \dQuote{Policy}, \dQuote{DeliveryPolicy}, or \dQuote{DisplayName}.}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{\code{get_topic_attrs} retrieves topic attributes, while \code{set_topic_attrs} can be used to set those attributes.}
\value{If successful, for \code{get_topic_attrs}: a named list containing some details of the request, for \code{set_topic_attrs}: a logical \code{TRUE} value. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{
\href{http://docs.aws.amazon.com/sns/latest/api/API_GetTopicAttributes.html}{GetTopicAttributes}
\href{http://docs.aws.amazon.com/sns/latest/api/API_SetTopicAttributes.html}{SetTopicAttributes}
}
\author{Thomas J. Leeper}
%\note{}
\seealso{
\code{\link{create_topic}}
}
%\examples{}
