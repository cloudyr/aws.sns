#' @title Execute SNS API Request
#' @description This is the workhorse function to execute calls to the SNS API.
#' 
#' This function constructs and signs an SNS API request and returns the
#' results thereof, or relevant debugging information in the case of error.
#' 
#' @param query An optional named list containing query string parameters and
#' their character values.
#' @param region A character string containing an AWS region. If missing, the
#' default \dQuote{us-east-1} is used.
#' @param key A character string containing an AWS Access Key ID. The default
#' is pulled from environment variable \dQuote{AWS_ACCESS_KEY_ID}.
#' @param secret A character string containing an AWS Secret Access Key. The
#' default is pulled from environment variable \dQuote{AWS_SECRET_ACCESS_KEY}.
#' @param ... Additional arguments passed to \code{\link[httr]{GET}}.
#' @return If successful, a named list. Otherwise, a data structure of class
#' \dQuote{aws-error} containing any error message(s) from AWS and information
#' about the request attempt.
#' @author Thomas J. Leeper
#' @import httr
#' @importFrom jsonlite fromJSON
#' @importFrom XML xmlParse xmlToList
#' @importFrom aws.signature signature_v4_auth
#' @export
snsHTTP <- function(query, 
                    region = Sys.getenv("AWS_DEFAULT_REGION","us-east-1"), 
                    key = Sys.getenv("AWS_ACCESS_KEY_ID"), 
                    secret = Sys.getenv("AWS_SECRET_ACCESS_KEY"), ...) {
    d_timestamp <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
    if(key == "") {
        H <- add_headers(`x-amz-date` = d_timestamp)
    } else {
        S <- signature_v4_auth(
               datetime = d_timestamp,
               region = region,
               service = "sns",
               verb = "GET",
               action = "/",
               query_args = query,
               canonical_headers = list(host = paste0("sns.",region,".amazonaws.com"),
                                        `x-amz-date` = d_timestamp),
               request_body = "",
               key = key, secret = secret)
        H <- add_headers(`x-amz-date` = d_timestamp, 
                         `x-amz-content-sha256` = S$BodyHash,
                         Authorization = S$SignatureHeader)
    }
    r <- GET(paste0("https://sns.",region,".amazonaws.com"), H, query = query, ...)
    if(http_status(r)$category == "client error") {
        x <- try(xmlToList(xmlParse(content(r, "text"))), silent = TRUE)
        if(inherits(x, "try-error"))
            x <- try(fromJSON(content(r, "text"))$Error, silent = TRUE)
        warn_for_status(r)
        h <- headers(r)
        out <- structure(x, headers = h, class = "aws_error")
        attr(out, "request_canonical") <- S$CanonicalRequest
        attr(out, "request_string_to_sign") <- S$StringToSign
        attr(out, "request_signature") <- S$SignatureHeader
    } else {
        out <- try(fromJSON(content(r, "text")), silent = TRUE)
        if(inherits(out, "try-error"))
            out <- structure(content(r, "text"), "unknown")
    }
    return(out)
}
