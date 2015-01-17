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
