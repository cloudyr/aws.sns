subscribe <- function(topic, endpoint, protocol, ...) {
    query_list <- list(TopicArn = topic, Action = "Subscribe")
    query_list$Endpoint <- endpoint
    protocol_list <- c("http","https","email","email-json","sms","sqs","application")
    if(!protocol %in% protocol_list)
        stop("'protocol' must be one of: ", paste0('"',protocol_list,'"', collapse = ", "))
    else
        query_list$Protocol <- protocol
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$SubscribeResponse, 
              RequestId = out$SubscribeResponse$ResponseMetadata$RequestId)
}

unsubscribe <- function(subscription, ...) {
    query_list <- list(SubscriptionArn = subscription, Action = "Unsubscribe")
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$UnsubscribeResponse, 
              RequestId = out$UnsubscribeResponse$ResponseMetadata$RequestId)
}

get_subscription_attrs <- function(subscription, ...) {
    query_list <- list(SubscriptionArn = subscription, Action = "GetSubscriptionAttributes")
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$GetSubscriptionAttributesResponse, 
              RequestId = out$GetSubscriptionAttributesResponse$ResponseMetadata$RequestId)
}

set_subscription_attrs <- function(subscription, attribute, ...) {
    query_list <- list(SubscriptionArn = subscription, Action = "SetSubscriptionAttributes")
    if(any(!names(attribute) %in% c("DeliveryPolicy","RawMessageDelivery")))
        stop("Attribute name must be 'DeliveryPolicy' or 'RawMessageDelivery'")
    else {
        query_list$AttributeName <- names(attribute)
        query_list$AttributeValue <- attribute[[1]]
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws-error"))
        return(out)
    structure(out$SetSubscriptionAttributesResponse, 
              RequestId = out$SetSubscriptionAttributesResponse$ResponseMetadata$RequestId)
}

list_subscriptions <- function(topic, token, ...) {
    if(missing(topic)) {
        query_list <- list(Action = "ListSubscriptions")
        if(!missing(token)) {
            query_list$NextToken <- token
        }
        out <- snsHTTP(query = query_list, ...)
        if(inherits(out, "aws-error"))
            return(out)
        structure(out$ListSubscriptionsResponse$ListSubscriptionsResult,
                  RequestId = out$ListSubscriptionsResponse$ResponseMetadata$RequestId)
    } else {
        query_list <- list(Action = "ListSubscriptionsByTopic", TopicArn = topic)
        if(!missing(token)) {
            query_list$NextToken <- token
        }
        out <- snsHTTP(query = query_list, ...)
        if(inherits(out, "aws-error"))
            return(out)
        structure(out$ListSubscriptionsByTopicResponse$ListSubscriptionsByTopicResult$Subscriptions,
                  NextToken = out$ListSubscriptionsByTopicResponse$ListSubscriptionsByTopicResultNextToken,
                  RequestId = out$ListSubscriptionsByTopicResponse$ResponseMetadata$RequestId)
    }
}
