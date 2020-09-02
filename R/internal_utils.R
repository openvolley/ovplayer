`%eq%` <- function (x, y) x == y & !is.na(x) & !is.na(y)

names_first_to_capital <- function(x, fun) {
    setNames(x, var2fc(if (missing(fun)) names(x) else vapply(names(x), fun, FUN.VALUE = "", USE.NAMES = FALSE)))
}

var2fc <- function(x) {
    vapply(x, function(z) gsub("_", " ", paste0(toupper(substr(z, 1, 1)), substr(z, 2, nchar(z)))), FUN.VALUE = "", USE.NAMES = FALSE)
}

## identify whether a given string looks like a youtube video ID
is_youtube_id <- function(z) nchar(z) == 11 & grepl("^[[:alnum:]_\\-]+$", z)
## is_youtube_id(c("7DnQWfTJiP4", "qwSIgTaWK5s", "a", "qwSIgTaW-5s", "_qwSIgTaWK5"))

js_str_nospecials <- function(z) gsub("['\"\\]+", "", z)

evaljs <- function(expr) {
    shiny::getDefaultReactiveDomain()$sendCustomMessage("evaljs", expr)
}

js_show <- function(id) evaljs(paste0("var el=$('#", id, "'); if (el.hasClass('shiny-bound-input')) { el.closest('.shiny-input-container').show(); } else { el.show(); }"))
js_hide <- function(id) evaljs(paste0("var el=$('#", id, "'); if (el.hasClass('shiny-bound-input')) { el.closest('.shiny-input-container').hide(); } else { el.hide(); }"))

