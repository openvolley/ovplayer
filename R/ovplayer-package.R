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
#' @importFrom shiny column fluidPage fluidRow HTML icon isolate observe observeEvent onSessionEnded onStop plotOutput reactive reactiveVal reactiveValues renderUI sliderInput uiOutput updateActionButton
#' @importFrom shinyMobile f7SingleLayout f7Navbar f7Fabs f7Fab f7Icon f7Shadow f7Card f7Slider f7Page
#' @importFrom stats na.omit setNames
#' @importFrom tidyr unite
NULL
