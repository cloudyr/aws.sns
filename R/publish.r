#' @title Publish to a topic or endpoint
#' @description Publish a message to a specified topic or application endpoint.
#' @details 
#' Publishes a message to a topic or an application endpoint. Messages can be
#' the same for all endpoints or customized so that, for example, a short
#' 140-character message is sent to SMS endpoints that are subscribed to a
#' topic while longer messages are sent to email endpoints, etc. The allowed
#' message types are: default, email, email-json, sqs, sms, http, https, and
#' application.
#' 
#' @param topic Optionally, a character string containing an SNS Topic Amazon
#' Resource Name (ARN). Must specify \code{topic} or \code{endpoint}.
#' @param endpoint Optionally, a character string containing an SNS Application
#' Endpoint ARN. Must specify \code{topic} or \code{endpoint}.
#' @param message Either a single character string containing a message to be
#' sent to all endpoints, or a named list of messages to be sent to specific
#' endpoints (where the names of each element correspond to endpoints).
#' @param subject Optionally, a character string containing a subject line
#' (e.g., to be used for an email endpoint).
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return If successful, a character string containing a message ID.
#' Otherwise, a data structure of class \dQuote{aws_error} containing any error
#' message(s) from AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_Publish.htmlPublish}
#' @export
publish <- function(topic, endpoint, message, subject, ...) {
    if(!missing(topic))
        query_list <- list(TopicArn = topic, Action = "Publish")
    else if(!missing(endpoint))
        query_list <- list(TargetArn = endpoint, Action = "Publish")
    else
        stop("Must supply either 'topic' or 'endpoint'")
    if(is.character(message)){
        query_list$Message <- message
    } else {
        query_list$Message <- toJSON(message, auto_unbox = TRUE)
        query_list$MessageStructure <- "json"
    }
    if(!missing(subject)) {
        if(nchar(subject[1]) > 100)
            stop("subject must be <= 100 characters")
        if(grepl("[[:cntrl:]]", subject[1]))
            stop("subject must not contain control characters")
        if(!grepl("^[[:alnum:]!]", subject[1]))
            stop("subject must start with letter, number, or exclamation point (!)")
        query_list$Subject <- subject
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$PublishResponse$PublishResult$MessageId, 
              RequestId = out$PublishResponse$ResponseMetadata$RequestId)
}
