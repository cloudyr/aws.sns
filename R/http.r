#' @title Execute SNS API Request
#' @description This is the workhorse function to execute calls to the SNS API.
#' @param query An optional named list containing query string parameters and their character values.
#' @param region A character string containing an AWS region. If missing, the default \dQuote{us-east-1} is used.
#' @param key A character string containing an AWS Access Key ID. See \code{\link[aws.signature]{locate_credentials}}.
#' @param secret A character string containing an AWS Secret Access Key. See \code{\link[aws.signature]{locate_credentials}}.
#' @param session_token Optionally, a character string containing an AWS temporary Session Token. See \code{\link[aws.signature]{locate_credentials}}.
#' @param ... Additional arguments passed to \code{\link[httr]{GET}}.
#' @return If successful, a named list. Otherwise, a data structure of class \dQuote{aws-error} containing any error message(s) from AWS and information about the request attempt.
#' @details This function constructs and signs an SNS API request and returns the results thereof, or relevant debugging information in the case of error.
#' @author Thomas J. Leeper
#' @import httr
#' @importFrom jsonlite fromJSON
#' @importFrom xml2 read_xml as_list
#' @importFrom aws.signature signature_v4_auth
#' @export
snsHTTP <- function(query, 
                    region = Sys.getenv("AWS_DEFAULT_REGION","us-east-1"), 
                    key = NULL, 
                    secret = NULL, 
                    session_token = NULL,
                    ...) {
    d_timestamp <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
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
           key = key, 
           secret = secret,
           session_token = session_token)
    headers <- list(`x-amz-date` = d_timestamp, 
                    `x-amz-content-sha256` = S$BodyHash,
                    Authorization = S$SignatureHeader)
    if (!is.null(session_token) && session_token != "") {
        headers[["x-amz-security-token"]] <- session_token
    }
    H <- do.call(add_headers, headers)
    
    r <- GET(paste0("https://sns.",region,".amazonaws.com"), H, query = query, ...)
    if (http_error(r)) {
        x <- try(as_list(read_xml(content(r, "text", encoding = "UTF-8"))), silent = TRUE)
        if (inherits(x, "try-error")) {
            x <- try(fromJSON(content(r, "text", encoding = "UTF-8"))$Error, silent = TRUE)
        }
        warn_for_status(r)
        h <- headers(r)
        out <- structure(x, headers = h, class = "aws_error")
        attr(out, "request_canonical") <- S$CanonicalRequest
        attr(out, "request_string_to_sign") <- S$StringToSign
        attr(out, "request_signature") <- S$SignatureHeader
    } else {
        out <- try(fromJSON(content(r, "text", encoding = "UTF-8")), silent = TRUE)
        if(inherits(out, "try-error"))
            out <- structure(content(r, "text", encoding = "UTF-8"), "unknown")
    }
    return(out)
}
