#' \pkg{ovplayer}
#'
#' A Shiny app for viewing volleyball video playlists.
#'
#' @name ovplayer
#' @docType package
#' @importFrom assertthat assert_that is.flag is.string
#' @importFrom dplyr distinct lag lead mutate tribble
#' @importFrom htmltools tagList tags
#' @importFrom methods as
#' @importFrom ovideo ov_video_control
#' @importFrom rlang .data
#' @importFrom shiny column fluidPage fluidRow isolate observe observeEvent onSessionEnded onStop plotOutput reactive reactiveVal reactiveValues renderUI sliderInput uiOutput updateActionButton
#' @importFrom stats na.omit setNames
NULL
