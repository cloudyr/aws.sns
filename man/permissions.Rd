\name{Permissions}
\alias{add_permission}
\alias{remove_permission}
\title{Add/remove access permissions}
\description{Add/remove permissions to publish to topic}
\usage{
add_permission(topic, label, permissions, ...)

remove_permission(topic, label, ...)
}
\arguments{
  \item{topic}{A character string containing an SNS Topic Amazon Resource Name (ARN).}
  \item{label}{A character string containing a label for the permission.}
  \item{permissions}{A named list of character strings, where the names of the list are AWS Account ID numbers and the list elements are SNS API endpoints (e.g. \dQuote{Publish}, \dQuote{Subscribe}, \dQuote{Unsubscribe}, etc.).}
  \item{...}{Additional arguments passed to \code{\link{snsHTTP}}.}
}
\details{Add or remove a permission, which grants another AWS account permission to use an SNS topic.}
\value{If successful, a logical \code{TRUE}. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.}
\references{
\href{http://docs.aws.amazon.com/sns/latest/api/API_AddPermission.html}{AddPermission}
\href{http://docs.aws.amazon.com/sns/latest/api/API_RemovePermission.html}{RemovePermission}
}
\author{Thomas J. Leeper}
%\note{}
%\seealso{}
%\examples{}
