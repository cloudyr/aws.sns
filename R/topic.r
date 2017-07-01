#' @rdname topics
#' @title Manage topics
#' @description Create, delete, and list topics
#' @param name A character string containing a (private) name for the topic.
#' @param topic A character string containing an SNS Topic Amazon Resource Name (ARN).
#' @param token A paging paramter used to return additional pages of results. This will be available in the \dQuote{NextToken} attribute of a previous call to \code{list_topics}.
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return For \code{create_topic}: If successful, a character string containing an SNS Topic ARN. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.
#' For \code{delete_topic}: If successful, a logical \code{TRUE}. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.
#' For \code{list_topics}: If successful, a data frame. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.
#' @details \code{create_topic} creates a new topic. The \code{name} is a private name for the topic. Use \code{\link{set_topic_attrs}} to set a publicly visible name for the topic. \code{delete_topic} deletes a named topic. \code{list_topics} lists all currently available topics.
#' 
#' \code{list_topics} lists topics. Up to 100 subscriptions are returned by each request. The \code{token} argument can be used to return additional results.
#' @author Thomas J. Leeper
#' @examples
#' \dontrun{
#'   top <- create_topic("new_topic")
#'   get_topic_attrs(top)
#'   list_topics()
#'   delete_topic(top)
#' }
#' @seealso \code{link{delete_topic}}
#' @references
#'  \href{http://docs.aws.amazon.com/sns/latest/api/API_CreateTopic.html}{CreateTopic}
#'  \href{http://docs.aws.amazon.com/sns/latest/api/API_DeleteTopic.html}{DeleteTopic}
#'  \href{http://docs.aws.amazon.com/sns/latest/api/API_ListTopics.html}{ListTopics}
#' @export
create_topic <- function(name, ...) {
    query_list <- list(Action = "CreateTopic")
    if (grepl("[[:space:]]", name)) {
        stop("'name' must not contain spaces")
    }
    if (nchar(name[1]) > 256 | nchar(name[1]) == 0) {
        stop("'name' must be between 1 and 256 ASCII characters")
    }
    query_list$Name <- name[1]
    out <- snsHTTP(query = query_list, ...)
    if (inherits(out, "aws_error")) {
        return(out)
    }
    structure(out$CreateTopicResponse$CreateTopicResult$TopicArn,
              RequestId = out$CreateTopicResponse$ResponseMetadata$RequestId)
}

#' @rdname topics
#' @export
delete_topic <- function(topic, ...) {
    out <- snsHTTP(query = list(TopicArn = topic, Action = "DeleteTopic"), ...)
    if (inherits(out, "aws_error")) {
        return(out)
    }
    structure(TRUE, 
              RequestId = out$DeleteTopicResponse$ResponseMetadata$RequestId)
}

#' @rdname topics
#' @export
list_topics <- function(token, ...) {
    if (missing(token)) {
        out <- snsHTTP(query = list(Action = "ListTopics"), ...)
    } else {
        out <- snsHTTP(query = list(Action = "ListTopics", NextToken = token), ...)
    }
    if (inherits(out, "aws_error")) {
        return(out)
    }
    structure(out$ListTopicsResponse$ListTopicsResult$Topics, 
              NextToken = out$ListTopicsResponse$ListTopicsResult$NextToken,
              RequestId = out$ListTopicsResponse$ResponseMetadata$RequestId)
}

#' @rdname get_topic_attrs
#' @title Get/set topic attributes
#' @description Get or set topic attributes
#' @param topic A character string containing an SNS Topic Amazon Resource Name (ARN).
#' @param attribute A named, single-element list containing a topic attribute. Name must be either \dQuote{Policy}, \dQuote{DeliveryPolicy}, or \dQuote{DisplayName}.
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return If successful, for \code{get_topic_attrs}: a named list containing some details of the request, for \code{set_topic_attrs}: a logical \code{TRUE} value. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.
#' @details \code{get_topic_attrs} retrieves topic attributes, while \code{set_topic_attrs} can be used to set those attributes.
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_GetTopicAttributes.html}{GetTopicAttributes}
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_SetTopicAttributes.html}{SetTopicAttributes}
#' @export
get_topic_attrs <- function(topic, ...) {
    out <- snsHTTP(query = list(TopicArn = topic, Action = "GetTopicAttributes"), ...)
    if (inherits(out, "aws_error")) {
        return(out)
    }
    structure(out$GetTopicAttributesResponse$GetTopicAttributesResult$Attributes, 
              RequestId = out$GetTopicAttributesResponse$ResponseMetadata$RequestId)
}

#' @rdname get_topic_attrs
#' @export
set_topic_attrs <- function(topic, attribute, ...) {
    query_list <- list(TopicArn = topic, Action = "SetTopicAttributes")
    if (any(!names(attributes) %in% c("Policy","DisplayName","DeliveryPolicy"))) {
        stop("Attribute name must be 'Policy', 'DiplayName', or 'DeliveryPolicy'")
    } else {
        query_list$AttributeName <- names(attribute)[1]
        query_list$AttributeValue <- attribute[[1]]
    }
    out <- snsHTTP(query = query_list, ...)
    if (inherits(out, "aws_error")) {
        return(out)
    }
    structure(TRUE, 
              RequestId = out$SetTopicAttributesResponse$ResponseMetadata$RequestId)
}

#' @rdname add_topic_permission
#' @title Add/remove access permissions
#' @aliases add__topic_permission remove_topic_permission
#' @description Add/remove permissions to publish to topic
#' @param topic A character string containing an SNS Topic Amazon Resource Name (ARN).
#' @param label A character string containing a label for the permission.
#' @param permissions A named list of character strings, where the names of the list are AWS Account ID numbers and the list elements are SNS API endpoints (e.g. \dQuote{Publish}, \dQuote{Subscribe}, \dQuote{Unsubscribe}, etc.).
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return If successful, a logical \code{TRUE}. Otherwise, a data structure of class \dQuote{aws_error} containing any error message(s) from AWS and information about the request attempt.
#' @details Add or remove a permission, which grants another AWS account permission to use an SNS topic.
#' @author Thomas J. Leeper
#' @references
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_AddPermission.html}{AddPermission}
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_RemovePermission.html}{RemovePermission}
#' @export
add_topic_permission <- function(topic, label, permissions, ...) {
    query_list <- list(TopicArn = topic, Label = label, Action = "AddPermission")
    # permissions should be a named list, with each element containing permissions
    len <- sapply(permissions, length)
    n <- as.list(rep(names(permissions), len))
    names(n) <- paste0("AWSAccountId.member.", 1:sum(len))
    p <- as.list(unlist(permissions))
    names(p) <- paste0("ActionName.member.", 1:sum(len))
    query_list <- c(query_list, n, p)
    out <- snsHTTP(query = query_list, ...)
    if (inherits(out, "aws_error")) {
        return(out)
    }
    structure(TRUE, 
              RequestId = out$AddPermissionResponse$ResponseMetadata$RequestId)
}

#' @rdname add_topic_permission
#' @export
remove_topic_permission <- function(topic, label, ...) {
    query_list <- list(TopicArn = topic, Label = label, Action = "RemovePermission")
    out <- snsHTTP(query = query_list, ...)
    if (inherits(out, "aws_error")) {
        return(out)
    }
    structure(TRUE, 
              RequestId = out$RemovePermissionResponse$ResponseMetadata$RequestId)
}

#' @rdname add_topic_permission
#' @export
add_permission <- function(...) {
    .Deprecated("add_topic_permission")
    add_topic_permission(...)
}

#' @rdname add_topic_permission
#' @export
remove_permission <- function(...) {
    .Deprecated("remove_topic_permission")
    add_topic_permission(...)
}
