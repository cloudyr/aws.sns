create_topic <- function(name, ...) {
    query_list <- list(Action = "CreateTopic")
    if(grepl("[[:space:]]", name))
        stop("'name' must not contain spaces")
    if(nchar(name[1]) > 256 | nchar(name[1]) == 0) {
        stop("'name' must be between 1 and 256 ASCII characters")
    } else {
        query_list$Name <- name[1]
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$CreateTopicResponse$CreateTopicResult$TopicArn,
              RequestId = out$CreateTopicResponse$ResponseMetadata$RequestId)
}

delete_topic <- function(topic, ...) {
    out <- snsHTTP(query = list(TopicArn = topic, Action = "DeleteTopic"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$DeleteTopicResponse, 
              RequestId = out$DeleteTopicResponse$ResponseMetadata$RequestId)
}

get_topic_attrs <- function(topic, ...) {
    out <- snsHTTP(query = list(TopicArn = topic, Action = "GetTopicAttributes"), ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$GetTopicAttributesResponse, 
              RequestId = out$GetTopicAttributesResponse$ResponseMetadata$RequestId)
}

set_topic_attrs <- function(topic, attribute, ...) {
    query_list <- list(TopicArn = topic, Action = "SetTopicAttributes")
    if(any(!names(attributes) %in% c("Policy","DisplayName","DeliveryPolicy")))
        stop("Attribute name must be 'Policy', 'DiplayName', or 'DeliveryPolicy'")
    else {
        query_list$AttributeName <- names(attribute)[1]
        query_list$AttributeValue <- attribute[[1]]
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$SetTopicAttributesResponse, 
              RequestId = out$SetTopicAttributesResponse$ResponseMetadata$RequestId)
}

list_topics <- function(token, ...) {
    if(missing(token)) {
        out <- snsHTTP(query = list(Action = "ListTopics"), ...)
    } else {
        out <- snsHTTP(query = list(Action = "ListTopics", NextToken = token), ...)
    }
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$ListTopicsResponse$ListTopicsResult$Topics, 
              NextToken = out$ListTopicsResponse$ListTopicsResult$NextToken,
              RequestId = out$ListTopicsResponse$ResponseMetadata$RequestId)
}

add_permission <- function(topic, label, permissions, ...) {
    query_list <- list(TopicArn = topic, Label = label, Action = "AddPermission")
    # permissions should be a named list, with each element containing permissions
    len <- sapply(permissions, length)
    n <- as.list(rep(names(permissions), len))
    names(n) <- paste0("AWSAccountId.member.", 1:sum(len))
    p <- as.list(unlist(permissions))
    names(p) <- paste0("ActionName.member.", 1:sum(len))
    query_list <- c(query_list, n, p)
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$AddPermissionResponse, 
              RequestId = out$AddPermissionResponse$ResponseMetadata$RequestId)
}

remove_permission <- function(topic, label, ...) {
    query_list <- list(TopicArn = topic, Label = label, Action = "RemovePermission")
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$RemovePermissionResponse, 
              RequestId = out$RemovePermissionResponse$ResponseMetadata$RequestId)
}
