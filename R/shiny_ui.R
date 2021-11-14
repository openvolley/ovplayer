ovp_shiny_ui <- function(app_data) {
    fluidPage(
        ovideo::ov_video_js(youtube = TRUE),
        tags$head(
                 tags$title(if (!is.null(app_data$title)) app_data$title else "Openvolley's - Volleyball Video Player"),
                 tags$style("#subtitle { border: 1px solid black; border-radius: 1px; padding: 5px; margin-left: 6px; background-color: lightblue; font-size: 14px;} #subtitleskill { border: 1px solid black; border-radius: 1px; padding: 5px; margin-left: 6px; background-color: coral; font-size: 14px;}"),
                 tags$style("#headerblock {border-radius:4px; padding:10px; margin-bottom:5px; min-height:120px; color:black;} h5 {font-weight: bold;}"),
                 if (!is.null(app_data$css)) tags$style(app_data$css)
             ),
        if (!is.null(app_data$ui_header)) {
            app_data$ui_header
        } else {
            fluidRow(id = "headerblock", column(6, tags$h2("Volleyball Video Player")),
                     column(3, offset = 3, tags$div(style = "text-align: center;", "Part of the", tags$br(), tags$img(src = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMTAiIGhlaWdodD0iMjEwIj48cGF0aCBkPSJNOTcuODMzIDE4Ny45OTdjLTQuNTUtLjM5Ni0xMi44MTItMS44ODYtMTMuNTgxLTIuNDQ5LS4yNDItLjE3Ny0xLjY5Mi0uNzUzLTMuMjIyLTEuMjgxLTI4LjY5Ni05Ljg5NS0zNS4xNy00NS45ODctMTMuODY4LTc3LjMyMyAyLjY3Mi0zLjkzIDIuNTc5LTQuMTktMS4zOTQtMy45MDYtMTIuNjQxLjktMjcuMiA2Ljk1Mi0zMy4wNjYgMTMuNzQ1LTUuOTg0IDYuOTI3LTcuMzI3IDE0LjUwNy00LjA1MiAyMi44NjIuNzE2IDEuODI2LS45MTgtLjE3LTEuODktMi4zMS03LjM1Mi0xNi4xNzQtOS4xODEtMzguNTYtNC4zMzctNTMuMDc0LjY5MS0yLjA3IDEuNDE1LTMuODY2IDEuNjEtMy45ODkuMTk0LS4xMjMuNzgyLTEuMDUzIDEuMzA3LTIuMDY2IDMuOTQ1LTcuNjE3IDkuNDU4LTEyLjg2MiAxNy44MzktMTYuOTcgMTIuMTcyLTUuOTY4IDI1LjU3NS01LjgyNCA0MS40My40NDUgNi4zMSAyLjQ5NSA4LjgwMiAzLjgwMSAxNi4wNDcgOC40MTMgNC4zNCAyLjc2MiA0LjIxMiAyLjg3NCAzLjU5NC0zLjE3My0yLjgyNi0yNy42ODEtMTYuOTA3LTQyLjE4NS0zNi4wNjgtMzcuMTUxLTQuMjU0IDEuMTE3IDUuMjQtMy4zMzggMTEuNjYtNS40NzMgMTMuMTgtNC4zOCAzOC45MzctNS43NzIgNDYuMDc0LTEuNDg4IDEuMjQ3LjU0NyAyLjIyOCAxLjA5NSAzLjI3NSAxLjYzIDQuMjkgMi4xMDcgMTEuNzMzIDcuNjk4IDE0LjI2NSAxMS40MjcuNDA3LjYgMS4yNyAxLjg2NiAxLjkxNyAyLjgxNCAxMS4zMDggMTYuNTY1IDguNjIzIDQxLjkxLTYuODM4IDY0LjU1Mi0zLjI0OSA0Ljc1OC0zLjI1OCA0Ljc0MiAyLjQ1IDQuMDE4IDMyLjQ4Mi00LjEyMiA0OC41MTUtMjEuOTM1IDM5LjU3OC00My45NzQtMS4xNC0yLjgwOSAxLjU2NiAxLjA2IDMuNTE4IDUuMDMyIDI5LjY5MyA2MC40MTctMjIuNTggMTA3Ljg1My03OS40OTggNzIuMTQzLTUuMDg0LTMuMTktNS4xMjMtMy4xNTItMy45MDIgMy44ODMgNC43MjEgMjcuMjIgMjUuNzgzIDQzLjU2MiA0NC4wODkgMzQuMjEgMS4zNjItLjY5NiAyLjIxLS43NSAyLjIxLS4xNDMtNi43NiAzLjg1Ny0xNi4wMTggNi41NTMtMjMuMTI2IDguMDkxLTcuNTU1IDEuNTQ3LTE4LjM2NiAyLjE3Mi0yNi4wMiAxLjUwNnoiIGZpbGw9IiMwMDA3NjYiLz48ZWxsaXBzZSBjeD0iMTA1Ljk3NSIgY3k9IjEwNC40NDEiIHJ4PSI5NC44NCIgcnk9IjkyLjU0MiIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwNzY2IiBzdHJva2Utd2lkdGg9IjEwLjc0Ii8+PC9zdmc+", style = "max-height:3em;"), tags$br(), tags$a(href = "https://github.com/openvolley", "openvolley", target = "_blank"), "project")))
        },
        tags$hr(),
        ovp_shiny_ui_main()
    )
}

ovp_shiny_ui_main <- function() {
    tagList(
        ## js to track size of video element
        tags$head(tags$script("var vo_rsztmr;
$(document).on('shiny:sessioninitialized', function() {
    Shiny.setInputValue('dv_height', $('#dv_player').innerHeight()); Shiny.setInputValue('dv_width', $('#dv_player').innerWidth()); Shiny.setInputValue('dvyt_height', $('#dvyt_player').innerHeight()); Shiny.setInputValue('dvyt_width', $('#dvyt_player').innerWidth()); Shiny.setInputValue('vo_voffset', $('#video_holder').innerHeight());
    $('#dv_player').prop('muted', true);
    dvjs_yt_first_mute = true;
    $(window).resize(function() {
      clearTimeout(vo_rsztmr);
      vo_rsztmr = setTimeout(vo_doneResizing, 500); });
    function vo_doneResizing() {
      Shiny.setInputValue('dv_height', $('#dv_player').innerHeight()); Shiny.setInputValue('dv_width', $('#dv_player').innerWidth()); Shiny.setInputValue('dvyt_height', $('#dvyt_player').innerHeight()); Shiny.setInputValue('dvyt_width', $('#dvyt_player').innerWidth()); Shiny.setInputValue('vo_voffset', $('#video_holder').innerHeight());
    }
});"),
    ##key press handling
    tags$script("$(document).on('keypress', function (e) { var el = document.activeElement; var len = -1; if (typeof el.value != 'undefined') { len = el.value.length; }; Shiny.onInputChange('cmd', e.which + '@' + el.className + '@' + el.id + '@' + el.selectionStart + '@' + len + '@' + new Date().getTime()); });"),
    tags$style(".showhide {border-radius: 20px; padding: 6px 9px; background: #668;} .showhide:hover {background: #668;} .showhide:focus {background: #668;} #video_holder:not(:fullscreen) #dvyt_player {height:480px;} #video_holder:fullscreen #dvyt_player {height:100vh;}")
),
uiOutput("error_dialog"),
fluidRow(column(8, tags$div(id = "video_holder", style = "position:relative;",
                            ovideo::ov_video_player(id = "dv_player", type = "local", controls = FALSE, poster = "data:image/gif,AAAA", style = "border: 1px solid black; width: 100%;", onloadstart = "set_vspinner();", oncanplay = "remove_vspinner();"),
                            ovideo::ov_video_player(id = "dvyt_player", type = "youtube", controls = FALSE, style = "border: 1px solid black; width: 100%; display:none;"),
                            tags$div(id = "vwm", tags$img(id = "vwm_img"))),
                plotOutput("video_overlay"),
                uiOutput("player_controls_ui", style = "margin-top: 12px;"),
                uiOutput("video_dialog")),
         column(4, uiOutput("tableheader"), DT::dataTableOutput("playstable"), uiOutput("chart_ui"))),
tags$hr(),
sliderInput("playback_rate", "Playback rate:", min = 0.1, max = 2.0, value = 1.0, step = 0.1),
tags$script("set_vspinner = function() { $('#dv_player').addClass('loading'); }"),
tags$script("remove_vspinner = function() { $('#dv_player').removeClass('loading'); }"),
tags$style("video.loading { background: black; }"),
tags$script("function dvjs_video_onstart() { Shiny.setInputValue('playstable_current_item', dvjs_video_controller.current); el=document.getElementById(\"subtitle\"); if (el !== null) { el.textContent=dvjs_video_controller.queue[dvjs_video_controller.current].subtitle; }; el=document.getElementById(\"subtitleskill\"); if (el !== null) { el.textContent=dvjs_video_controller.queue[dvjs_video_controller.current].subtitleskill; }; if (dvjs_video_controller.type == 'youtube') { Shiny.setInputValue('dvyt_height', $('#dvyt_player').innerHeight()); Shiny.setInputValue('dvyt_width', $('#dvyt_player').innerWidth()); } else { Shiny.setInputValue('dv_height', $('#dv_player').innerHeight()); Shiny.setInputValue('dv_width', $('#dv_player').innerWidth()); }; Shiny.setInputValue('vo_voffset', $('#video_holder').innerHeight()); }"),
tags$div(style = "display:none;", icon("question-circle")))
}

ovp_shiny_mobile_ui <- function(app_data) {
    f7Page(
        title = if (!is.null(app_data$title)) app_data$title else "Openvolley's - Volleyball Video Player",
        ovideo::ov_video_js(youtube = TRUE),
        tags$head(
            tags$style("#subtitle { border: 1px solid black; border-radius: 1px; padding: 5px; margin-left: 6px; background-color: lightblue; font-size: 14px;} #subtitleskill { border: 1px solid black; border-radius: 1px; padding: 5px; margin-left: 6px; background-color: coral; font-size: 14px;}"),
            tags$style("#headerblock {border-radius:4px; padding:10px; margin-bottom:5px; min-height:120px; color:black;} h5 {font-weight: bold;}"),
            if (!is.null(app_data$css)) tags$style(app_data$css)
        ),
        ovp_shiny_ui_mobile_main(app_data)
    )
}

ovp_shiny_ui_mobile_main <- function(app_data) {
    f7SingleLayout(
        navbar = if (!is.null(app_data$ui_navbar)) {
                     app_data$ui_navbar
                 } else {
                     f7Navbar(title = tags$div(tags$img(src = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMTAiIGhlaWdodD0iMjEwIj48cGF0aCBkPSJNOTcuODMzIDE4Ny45OTdjLTQuNTUtLjM5Ni0xMi44MTItMS44ODYtMTMuNTgxLTIuNDQ5LS4yNDItLjE3Ny0xLjY5Mi0uNzUzLTMuMjIyLTEuMjgxLTI4LjY5Ni05Ljg5NS0zNS4xNy00NS45ODctMTMuODY4LTc3LjMyMyAyLjY3Mi0zLjkzIDIuNTc5LTQuMTktMS4zOTQtMy45MDYtMTIuNjQxLjktMjcuMiA2Ljk1Mi0zMy4wNjYgMTMuNzQ1LTUuOTg0IDYuOTI3LTcuMzI3IDE0LjUwNy00LjA1MiAyMi44NjIuNzE2IDEuODI2LS45MTgtLjE3LTEuODktMi4zMS03LjM1Mi0xNi4xNzQtOS4xODEtMzguNTYtNC4zMzctNTMuMDc0LjY5MS0yLjA3IDEuNDE1LTMuODY2IDEuNjEtMy45ODkuMTk0LS4xMjMuNzgyLTEuMDUzIDEuMzA3LTIuMDY2IDMuOTQ1LTcuNjE3IDkuNDU4LTEyLjg2MiAxNy44MzktMTYuOTcgMTIuMTcyLTUuOTY4IDI1LjU3NS01LjgyNCA0MS40My40NDUgNi4zMSAyLjQ5NSA4LjgwMiAzLjgwMSAxNi4wNDcgOC40MTMgNC4zNCAyLjc2MiA0LjIxMiAyLjg3NCAzLjU5NC0zLjE3My0yLjgyNi0yNy42ODEtMTYuOTA3LTQyLjE4NS0zNi4wNjgtMzcuMTUxLTQuMjU0IDEuMTE3IDUuMjQtMy4zMzggMTEuNjYtNS40NzMgMTMuMTgtNC4zOCAzOC45MzctNS43NzIgNDYuMDc0LTEuNDg4IDEuMjQ3LjU0NyAyLjIyOCAxLjA5NSAzLjI3NSAxLjYzIDQuMjkgMi4xMDcgMTEuNzMzIDcuNjk4IDE0LjI2NSAxMS40MjcuNDA3LjYgMS4yNyAxLjg2NiAxLjkxNyAyLjgxNCAxMS4zMDggMTYuNTY1IDguNjIzIDQxLjkxLTYuODM4IDY0LjU1Mi0zLjI0OSA0Ljc1OC0zLjI1OCA0Ljc0MiAyLjQ1IDQuMDE4IDMyLjQ4Mi00LjEyMiA0OC41MTUtMjEuOTM1IDM5LjU3OC00My45NzQtMS4xNC0yLjgwOSAxLjU2NiAxLjA2IDMuNTE4IDUuMDMyIDI5LjY5MyA2MC40MTctMjIuNTggMTA3Ljg1My03OS40OTggNzIuMTQzLTUuMDg0LTMuMTktNS4xMjMtMy4xNTItMy45MDIgMy44ODMgNC43MjEgMjcuMjIgMjUuNzgzIDQzLjU2MiA0NC4wODkgMzQuMjEgMS4zNjItLjY5NiAyLjIxLS43NSAyLjIxLS4xNDMtNi43NiAzLjg1Ny0xNi4wMTggNi41NTMtMjMuMTI2IDguMDkxLTcuNTU1IDEuNTQ3LTE4LjM2NiAyLjE3Mi0yNi4wMiAxLjUwNnoiIGZpbGw9IiMwMDA3NjYiLz48ZWxsaXBzZSBjeD0iMTA1Ljk3NSIgY3k9IjEwNC40NDEiIHJ4PSI5NC44NCIgcnk9IjkyLjU0MiIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjMDAwNzY2IiBzdHJva2Utd2lkdGg9IjEwLjc0Ii8+PC9zdmc+", style = "max-height:2em;"), tags$a(href = "https://github.com/openvolley", "openvolley", target = "_blank"), "project"),
                              hairline = TRUE, shadow = TRUE, leftPanel = FALSE, rightPanel = FALSE)
                 },
        f7Fabs(
            position = "left-bottom",
            color = "pink",
            sideOpen = "top",
            extended = TRUE,
            f7Fab(inputId = "fullscreen_player", label = f7Icon("expand")),
            f7Fab(inputId = "back_player", label = f7Icon("gobackward_minus")),
            f7Fab(inputId = "next_player", label = f7Icon("arrow_right")),
            f7Fab(inputId = "prev_player", label = f7Icon("arrow_left")),
            f7Fab(inputId = "play_player", label = f7Icon("playpause")),
            f7Fab(inputId = "start_player", label = f7Icon("greaterthan"))
        ), 
        f7Shadow(
            intensity = 16,
            hover = TRUE,
            f7Card(
                tagList(
                    ## js to track size of video element
                    tags$head(tags$script("var vo_rsztmr;
                              $(document).on('shiny:sessioninitialized', function() {
                              Shiny.setInputValue('dv_height', $('#dv_player').innerHeight()); Shiny.setInputValue('dv_width', $('#dv_player').innerWidth()); Shiny.setInputValue('dvyt_height', $('#dvyt_player').innerHeight()); Shiny.setInputValue('dvyt_width', $('#dvyt_player').innerWidth()); Shiny.setInputValue('vo_voffset', $('#video_holder').innerHeight());
                              $('#dv_player').prop('muted', true);
                              $('html').removeClass('theme-dark');
                              dvjs_yt_first_mute = true;
                              $(window).resize(function() {
                              clearTimeout(vo_rsztmr);
                              vo_rsztmr = setTimeout(vo_doneResizing, 500); });
                              function vo_doneResizing() {
                              Shiny.setInputValue('dv_height', $('#dv_player').innerHeight()); Shiny.setInputValue('dv_width', $('#dv_player').innerWidth()); Shiny.setInputValue('dvyt_height', $('#dvyt_player').innerHeight()); Shiny.setInputValue('dvyt_width', $('#dvyt_player').innerWidth()); Shiny.setInputValue('vo_voffset', $('#video_holder').innerHeight());
                              }
                              });"),
                              tags$style(".showhide {border-radius: 20px; padding: 6px 9px; background: #668;} .showhide:hover {background: #668;} .showhide:focus {background: #668;}")
                    ),
                    uiOutput("error_dialog"),
                    #fluidRow(column(8, 
                                    tags$div(id = "video_holder",
                                             ovideo::ov_video_player(id = "dv_player", type = "local", controls = FALSE, poster = "data:image/gif,AAAA", style = "border: 1px solid black; width: 98%;", onloadstart = "set_vspinner();", oncanplay = "remove_vspinner();"),
                                             ovideo::ov_video_player(id = "dvyt_player", type = "youtube", controls = FALSE, style = "border: 1px solid black; width: 98%; height: 480px; display:none;")), ## start hidden
                                    plotOutput("video_overlay"),
                                    #uiOutput("player_controls_score_ui", style = "margin-top: 12px;"),
                                    uiOutput("player_controls_skill_ui", style = "margin-top: 12px;"),
                                    #uiOutput("player_controls_ui", style = "margin-top: 12px;"),
                                    uiOutput("video_dialog"),#),
                            # column(4, 
                                    uiOutput("tableheader"),
                                    DT::dataTableOutput("playstable"),
                            #        uiOutput("chart_ui")
                             #)),
                    tags$hr(),
                    #sliderInput("playback_rate", "Playback rate:", min = 0.1, max = 2.0, value = 1.0, step = 0.1),
                    f7Slider("playback_rate", "Playback rate:", min = 0.1, max = 2.0, value = 1.0, step = 0.1),
                    uiOutput("extra_ui"),
                    tags$script("set_vspinner = function() { $('#dv_player').addClass('loading'); }"),
                    tags$script("remove_vspinner = function() { $('#dv_player').removeClass('loading'); }"),
                    tags$style("video.loading { background: black; }"),
                    tags$script("function dvjs_video_onstart() { Shiny.setInputValue('playstable_current_item', dvjs_video_controller.current); el=document.getElementById(\"subtitle\"); if (el !== null) { el.textContent=dvjs_video_controller.queue[dvjs_video_controller.current].subtitle; }; el=document.getElementById(\"subtitleskill\"); if (el !== null) { el.textContent=dvjs_video_controller.queue[dvjs_video_controller.current].subtitleskill; }; if (dvjs_video_controller.type == 'youtube') { Shiny.setInputValue('dvyt_height', $('#dvyt_player').innerHeight()); Shiny.setInputValue('dvyt_width', $('#dvyt_player').innerWidth()); } else { Shiny.setInputValue('dv_height', $('#dv_player').innerHeight()); Shiny.setInputValue('dv_width', $('#dv_player').innerWidth()); }; Shiny.setInputValue('vo_voffset', $('#video_holder').innerHeight()); }"),
                    tags$div(style = "display:none;", icon("question-circle"))
                )
            )
        )
    )
}
