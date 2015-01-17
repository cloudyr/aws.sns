create_app <- function(name, platform, attribute, ...) {
    query_list <- list(Action = "CreatePlatformApplication", PlatformApplicationArn = app)
    if(nchar(name[1]) > 256 | nchar(name[1]) == 0) {
        stop("name must be between 1 and 256 ASCII characters")
    } else {
        query_list$Name <- name[1]
    }
    plist <- c("ADM", "APNS", "APNS_SANDBOX", "GCM")
    if(!platform[1] %in% plist) {
        stop(paste0("Platform must be one of ", paste0("'",plist,"'",collapse=", ")))
    } else {
        query_list$Platform <- platform[1]
    }
    plist <- c("PlatformCredential", "PlatformPrincipal", "EventEndpointCreated", 
               "EventEndpointDeleted", "EventEndpointUpdated", "EventDeliveryFailure")
    if(any(!names(attribute) %in% plist)) {
        stop(paste0("Attribute names must be one of ", paste0("'",plist,"'",collapse=", ")))
    } else {
        len <- sapply(attribute, length)
        n <- as.list(rep(names(attribute), len))
        names(n) <- paste0("Attributes.entry.", 1:sum(len), ".key")
        p <- as.list(unlist(attribute))
        names(p) <- paste0("Attributes.entry.", 1:sum(len), ".value")
        query_list <- c(query_list, n, p)
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$CreatePlatformApplicationResponse$CreatePlatformApplicationResult,
              RequestId = out$CreatePlatformApplicationResponse$ResponseMetadata$RequestId)
}

delete_app <- function(app, ...) {
    query_list <- list(Action = "DeletePlatformApplication", PlatformApplicationArn = app)
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$DeletePlatformApplicationResponse$DeletePlatformApplicationResult,
              RequestId = out$DeletePlatformApplicationResponse$ResponseMetadata$RequestId)
}

get_app_attrs <- function(app, ...) {
    query_list <- list(Action = "GetPlatformApplicationAttributes", PlatformApplicationArn = app)
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$GetPlatformApplicationAttributesResponse$GetPlatformApplicationAttributesResult,
              RequestId = out$GetPlatformApplicationAttributesResponse$ResponseMetadata$RequestId)
}

set_app_attrs <- function(app, attribute, ...) {
    query_list <- list(Action = "SetPlatformApplicationAttributes", PlatformApplicationArn = app)
    plist <- c("PlatformCredential", "PlatformPrincipal", "EventEndpointCreated", "EventEndpointDeleted",
               "EventEndpointUpdated", "EventDeliveryFailure")
    if(any(!names(attribute) %in% plist)) {
        stop(paste0("Attribute names must be one of ", paste0("'",plist,"'",collapse=", ")))
    } else {
        len <- sapply(attribute, length)
        n <- as.list(rep(names(attribute), len))
        names(n) <- paste0("Attributes.entry.", 1:sum(len), ".key")
        p <- as.list(unlist(attribute))
        names(p) <- paste0("Attributes.entry.", 1:sum(len), ".value")
        query_list <- c(query_list, n, p)
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$SetPlatformApplicationAttributesResponse$SetPlatformApplicationAttributesResult,
              RequestId = out$SetPlatformApplicationAttributesResponse$ResponseMetadata$RequestId)
}

create_app_endpoint <- function(app, attribute, token, custom_data, ...) {
    query_list <- list(Action = "CreatePlatformEndpoint", PlatformApplicationArn = app)
    if(any(!names(attribute) %in% c("CustomUserData", "Enabled", "Token"))) {
        warnings("Unrecognized attribute names. Should be 'CustomUserData', 'Enabled', or 'Token'")
    } else {
        len <- sapply(attribute, length)
        n <- as.list(rep(names(attribute), len))
        names(n) <- paste0("Attributes.entry.", 1:sum(len), ".key")
        p <- as.list(unlist(attribute))
        names(p) <- paste0("Attributes.entry.", 1:sum(len), ".value")
        query_list <- c(query_list, n, p)
    }
    query_list$Token <- token
    if(!missing(custom_data))
        query_list$CustomUserData <- custom_data
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$CreatePlatformEndpointResponse$CreatePlatformEndpointResult,
              RequestId = out$CreatePlatformEndpointResponse$ResponseMetadata$RequestId)
}

get_endpoint_attrs <- function(endpoint, ...) {
    query_list <- list(Action = "GetEndpointAttributes", EndpointArn = endpoint)
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$GetEndpointAttributesResponse$GetEndpointAttributesResult,
              RequestId = out$GetEndpointAttributesResponse$ResponseMetadata$RequestId)
}

set_endpoint_attrs <- function(endpoint, attribute, ...) {
    query_list <- list(Action = "SetEndpointAttributes", EndpointArn = endpoint)
    if(any(!names(attribute) %in% c("CustomUserData", "Enabled", "Token"))) {
        warning("Unrecognized attribute names. Should be 'CustomUserData', 'Enabled', or 'Token'")
    } else {
        len <- sapply(attribute, length)
        n <- as.list(rep(names(attribute), len))
        names(n) <- paste0("Attributes.entry.", 1:sum(len), ".key")
        p <- as.list(unlist(attribute))
        names(p) <- paste0("Attributes.entry.", 1:sum(len), ".value")
        query_list <- c(query_list, n, p)
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$SetEndpointAttributesResponse$SetEndpointAttributesResult,
              RequestId = out$SetEndpointAttributesResponse$ResponseMetadata$RequestId)
}

list_apps <- function(token, ...) {
    query_list <- list(Action = "ListPlatformApplications")
    if(!missing(token)) {
        query_list$NextToken <- token
    }
    out <- snsHTTP(query = query_list, ...)
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$ListPlatformApplicationsResponse$ListPlatformApplicationsResult$PlatformApplications,
              NextToken = out$ListPlatformApplicationsResponse$ListPlatformApplicationsResult$NextToken,
              RequestId = out$ListPlatformApplicationsResponse$ResponseMetadata$RequestId)
}

list_app_endpoints <- function(app, token, ...) {
    if(missing(token)) {
        out <- snsHTTP(query = list(Action = "ListEndpointsByPlatformApplication"), ...)
    } else {
        out <- snsHTTP(query = list(Action = "ListEndpointsByPlatformApplication", NextToken = token), ...)
    }
    if(inherits(out, "aws_error"))
        return(out)
    structure(out$ListEndpointsByPlatformApplicationResponse$ListEndpointsByPlatformApplicationResult$Endpoints, 
              NextToken = out$ListEndpointsByPlatformApplicationResponse$ListEndpointsByPlatformApplicationResult$NextToken,
              RequestId = out$ListEndpointsByPlatformApplicationResponse$ResponseMetadata$RequestId)
}
