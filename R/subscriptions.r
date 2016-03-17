#' Subscribe to a topic
#' 
#' Subscribes an endpoint to the specified SNS topic.
#' 
#' Initiates a subscription of an endpoint to an SNS topic. For example, this
#' is used to add an email address endpoint to a topic. Subscriptions need to
#' be confirmed by the endpoint. For example, an SMS endpoint will require an
#' SMS response to an subscription invitation message. Subscriptions can be
#' removed using \code{\link{unsubscribe}} (or whatever method is described in
#' the invitation message); thus subscriptions can be handled by both users and
#' administrator (you).
#' 
#' @param topic A character string containing an SNS Topic Amazon Resource Name
#' (ARN).
#' @param endpoint A character string containing the endpoint to be subscribed
#' (e.g., an email address).
#' @param protocol The allowed protocol types are: default, email, email-json,
#' sqs, sms, http, https, and application.
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return If successful, a character string containing a subscription ARN.
#' Otherwise, a data structure of class \dQuote{aws_error} containing any error
#' message(s) from AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{unsubscribe}} \code{\link{list_subscriptions}}
#' @references
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_Subscribe.htmlSubscribe}
#' @export
subscribe <- function(topic, endpoint, protocol, ...) {
    query_list <- list(TopicArn = topic, Action = "Subscribe")
    query_list$Endpoint <- endpoint
    protocol_list <- c("http","https","email","email-json","sms","sqs","application")
    if(!protocol %in% protocol_list)
        stop("'protocol' must be one of: ", paste0('"',protocol_list,'"', collapse = ", "))
    else
        query_list$Protocol <- protocol
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$SubscribeResponse$SubscribeResult$SubscriptionArn, 
              RequestId = out$SubscribeResponse$ResponseMetadata$RequestId)
}


#' Unsubscribe from a topic
#' 
#' Cancels an endpoint's subscription to a topic.
#' 
#' Unsubscribes an endpoint from an SNS topic.
#' 
#' @param subscription A character string containing an SNS Subscription Amazon
#' Resource Name (ARN).
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return If successful, a logical \code{TRUE}. Otherwise, a data structure of
#' class \dQuote{aws_error} containing any error message(s) from AWS and
#' information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{unsubscribe}} \code{\link{list_subscriptions}}
#' @references
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_Unsubscribe.htmlUnsubscribe}
#' @export
unsubscribe <- function(subscription, ...) {
    query_list <- list(SubscriptionArn = subscription, Action = "Unsubscribe")
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(TRUE, 
              RequestId = out$UnsubscribeResponse$ResponseMetadata$RequestId)
}

#' @rdname get_subscription_attrs
#' @title Get/set subscription attributes
#' @aliases get_subscription_attrs set_subscription_attrs
#' @description Get or set subscription attributes
#' @details 
#' \code{get_subscription_attrs} retrieves subscription attributes, while
#' \code{set_subscription_attrs} can be used to set those attributes.
#' 
#' @param subscription A character string containing an SNS Subscription Amazon
#' Resource Name (ARN).
#' @param attribute A named, single-element list containing a subscription
#' attribute. Name must be either \dQuote{DeliveryPolicy} or
#' \dQuote{RawMessageDelivery}.
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return If successful, for \code{get_subscription_attrs}: a named list
#' containing some details of the request, for \code{set_subscription_attrs}: a
#' logical \code{TRUE} value. Otherwise, a data structure of class
#' \dQuote{aws_error} containing any error message(s) from AWS and information
#' about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{subscribe}} \code{link{unsubscribe}}
#' \code{link{list_subscriptions}}
#' @references
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_GetSubscriptionAttributes.htmlGetSubscriptionAttributes}
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_SetSubscriptionAttributes.htmlSetSubscriptionAttributes}
#' @export
get_subscription_attrs <- function(subscription, ...) {
    query_list <- list(SubscriptionArn = subscription, Action = "GetSubscriptionAttributes")
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$GetSubscriptionAttributesResponse$GetSubscriptionAttributesResult$Attributes, 
              RequestId = out$GetSubscriptionAttributesResponse$ResponseMetadata$RequestId)
}

#' @rdname get_subscription_attrs
#' @export
set_subscription_attrs <- function(subscription, attribute, ...) {
    query_list <- list(SubscriptionArn = subscription, Action = "SetSubscriptionAttributes")
    if(any(!names(attribute) %in% c("DeliveryPolicy","RawMessageDelivery")))
        stop("Attribute name must be 'DeliveryPolicy' or 'RawMessageDelivery'")
    else {
        query_list$AttributeName <- names(attribute)
        query_list$AttributeValue <- attribute[[1]]
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(TRUE, 
              RequestId = out$SetSubscriptionAttributesResponse$ResponseMetadata$RequestId)
}



#' List subscriptions for a topic
#' 
#' Lists subscriptions for a specified topic
#' 
#' Lists subscriptions for a specified topic. Up to 100 subscriptions are
#' returned by each request. The \code{token} argument can be used to return
#' additional results.
#' 
#' @param topic A character string containing an SNS Topic Amazon Resource Name
#' (ARN).
#' @param token A paging paramter used to return additional pages of results.
#' This will be available in the \dQuote{NextToken} attribute of a previous
#' call to \code{list_subscriptions}.
#' @param ... Additional arguments passed to \code{\link{snsHTTP}}.
#' @return If successful, a dataframe containing details of . Otherwise, a data
#' structure of class \dQuote{aws_error} containing any error message(s) from
#' AWS and information about the request attempt.
#' @author Thomas J. Leeper
#' @seealso \code{link{subscribe}} \code{link{unsubscribe}}
#' \code{link{get_subscription_attrs}}
#' @references
#' \href{http://docs.aws.amazon.com/sns/latest/api/API_ListSubscriptions.htmlListSubscriptions}
list_subscriptions <- function(topic, token, ...) {
    if(missing(topic)) {
        query_list <- list(Action = "ListSubscriptions")
        if(!missing(token)) {
            query_list$NextToken <- token
        }
        out <- snsHTTP(query = query_list, ...)
        if(inherits(out, "aws_error"))
            return(out)
        structure(out$ListSubscriptionsResponse$ListSubscriptionsResult,
                  RequestId = out$ListSubscriptionsResponse$ResponseMetadata$RequestId)
    } else {
        query_list <- list(Action = "ListSubscriptionsByTopic", TopicArn = topic)
        if(!missing(token)) {
            query_list$NextToken <- token
        }
        out <- snsHTTP(query = query_list, ...)
        if(inherits(out, "aws_error"))
            return(out)
        dat <- out$ListSubscriptionsByTopicResponse$ListSubscriptionsByTopicResult$Subscriptions
        if(!length(dat)) {
            dat <- setNames(as.data.frame(matrix(NA_character_, nrow=0, ncol=4), stringsAsFactors = FALSE), 
                            c("Endpoint","Owner Protocol","SubscriptionArn","TopicArn"))
        }
        structure(dat,
                  NextToken = out$ListSubscriptionsByTopicResponse$ListSubscriptionsByTopicResultNextToken,
                  RequestId = out$ListSubscriptionsByTopicResponse$ResponseMetadata$RequestId)
    }
}
