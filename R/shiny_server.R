ovp_shiny_server <- function(app_data) {
    function(input, output, session) {
        plays_cols_to_show_default <- c("video_time", "code", "set_number", "home_team_score", "visiting_team_score")
        plays_cols_to_show <- if (!is.null(app_data$plays_cols_to_show)) app_data$plays_cols_to_show else plays_cols_to_show_default ## this will be modified depending on columns actually in playlist
        playlist_in <- reactiveVal(app_data$playlist)

        playstable_data <- reactiveVal(NULL)
        output$playstable <- DT::renderDataTable({
            mydat <- playstable_data()
            
            mydat[,"code"] <- sapply(mydat[,"code"], function(x) paste0('<strong style="background-color:white;border-radius: 5px;padding: 3px; border: 2px solid #73AD21;">',x,'</strong>'))
            if (!is.null(mydat)) {
                DT::datatable(names_first_to_capital(mydat[, plays_cols_to_show, drop = FALSE]), rownames = FALSE,
                              extensions = "Scroller", selection = list(mode = "single", selected = 1, target = "row"),
                              escape = FALSE, 
                              options = list(sDom = '<"top">t<"bottom">rlp', deferRender = TRUE, scrollY = 200, scroller = TRUE, ordering = FALSE)) ## no column sorting
            } else {
                NULL
            }
        })
        playstable_proxy <- DT::dataTableProxy("playstable", deferUntilFlush = TRUE)
        master_playstable_selected_row <- -99L ## non-reactive
        playstable_select_row <- function(rw) {
            ##if (!is.null(rw) && !is.na(rw) && (is.null(input$playstable_rows_selected) || rw != input$playstable_rows_selected)) {
            if (!is.null(rw) && !is.na(rw) && (rw != master_playstable_selected_row)) {
                master_playstable_selected_row <<- rw
                DT::selectRows(playstable_proxy, rw)
                scroll_playstable(rw)
            }
        }
        scroll_playstable <- function(rw = NULL) {
            selr <- if (!is.null(rw)) rw else input$playstable_rows_selected
            if (!is.null(selr)) {
                ## scrolling works on the VISIBLE row index, so it depends on any column filters that might have been applied
                visible_rowidx <- which(input$playstable_rows_all == selr)
                scrollto <- max(visible_rowidx-1-2, 0) ## -1 for zero indexing, -2 to keep the selected row 2 from the top
                evaljs(paste0("$('#playstable').find('.dataTable').DataTable().scroller.toPosition(", scrollto, ", false);"))
            }
        }
        ## when player changes item, it triggers input$playstable_current_item via the video_onstart() function. Update the selected row in the playstable
        observeEvent(input$playstable_current_item, {
            if (!is.null(input$playstable_current_item)) {
                ## input$playstable_current_item is 0-based
                isolate(pl <- playlist())
                np <- nrow(pl)
                if (input$playstable_current_item < np) {
                    playstable_select_row(input$playstable_current_item+1)
                    if ("comments" %in% names(pl)) {
                        output$video_dialog <- renderUI({
                            this <- pl$comments[[input$playstable_current_item+1]]
                            if (inherits(this, "shiny.tag")) {
                                this
                            } else if (is.character(this) && !is.na(this) && length(this) == 1) {
                                tags$p(this)
                            } else {
                                NULL
                            }
                        })
                    } else {
                        output$video_dialog <- renderUI(NULL)
                    }
                } else {
                    ## reached the end of the playlist
                    master_playstable_selected_row <<- -99L
                    output$video_dialog <- renderUI(NULL)
                }
            }
        })
        ## when the user chooses a row in the playstable, it will be selected by that click action, so we just need to play it
        ## use input$playstable_cell_clicked rather than input$playstable_rows_selected to detect user input, because the latter is also triggered by the player incrementing rows
        observeEvent(input$playstable_cell_clicked, { ## note, can't click the same row twice in a row ...
            clicked_row <- input$playstable_cell_clicked$row ## 1-based
            if (!is.null(clicked_row) && !is.na(clicked_row) && clicked_row != master_playstable_selected_row) { ## TODO take this last condition out?
                master_playstable_selected_row <<- clicked_row
                evaljs(paste0("dvjs_video_controller.current=", clicked_row-1, "; dvjs_video_play();"))
            }
        })

        playlist <- reactive({
            pl <- playlist_in()
            if (!is.null(pl) && nrow(pl) > 0 && all(c("video_src", "type") %in% names(pl))) {
                ## populate the plays table data
                plays_cols_to_show <<- intersect(names(pl), plays_cols_to_show)
                playstable_data(pl[, plays_cols_to_show])
                lidx <- !grepl("^http[s]?://", pl$video_src, ignore.case = TRUE) & !is_youtube_id(pl$video_src)
                if (any(lidx) && is.string(app_data$video_serve_method) && app_data$video_serve_method %in% c("lighttpd", "servr")) {
                    ## we are serving the video through the local server
                    ##  the video_src entries in the playlist will be absolute paths to files
                    ##  to serve these, make symlinks in its document root directory pointing to the actual video files
                    vf <- fs::path_norm(pl$video_src[lidx])
                    for (thisf in vf) {
                        if (fs::file_exists(thisf)) {
                            symlink_abspath <- fs::path_abs(file.path(app_data$video_server_dir, basename(thisf)))
                            suppressWarnings(try(unlink(symlink_abspath), silent = TRUE))
                            thisf <- gsub(" ", "\\\\ " , thisf) ## this may not work on Windows
                            fs::link_create(thisf, symlink_abspath)
                            onStop(function() try({ unlink(symlink_abspath) }, silent = TRUE))
                            onSessionEnded(function() try({ unlink(symlink_abspath) }, silent = TRUE))
                        } else {
                            ## video file does not exist!
                            stop("video file ", thisf, " does not exist, not handled yet")
                        }
                    }
                    pl$video_src[lidx] <- file.path(app_data$video_server_url, basename(pl$video_src[lidx]))
                } else if (is.function(app_data$video_serve_method)) {
                    pl$video_src <- app_data$video_serve_method(pl$video_src, pl$file)
                } else if (is.string(app_data$video_serve_method) && app_data$video_serve_method %in% c("none")) {
                    ## do nothing
                } else {
                    stop("unrecognized video_serve_method: ", app_data$video_serve_method)
                }
##                    event_list <- mutate(event_list, skill = case_when(.data$skill %in% c("Freeball dig", "Freeball over") ~ "Freeball", TRUE ~ .data$skill), ## ov_video needs just "Freeball"
##                                         skilltype = case_when(.data$skill %in% c("Serve", "Reception", "Dig", "Freeball", "Block", "Set") ~ .data$skill_type,
##                                                                           .data$skill == "Attack" ~ .data$attack_description),
##                                         subtitle = js_str_nospecials(paste("Set", .data$set_number, "-", .data$home_team, .data$home_team_score, "-", .data$visiting_team_score, .data$visiting_team)),
##                                         subtitleskill = js_str_nospecials(paste(.data$player_name, "-", .data$skilltype, ":", .data$evaluation_code)))
##                    event_list <- dplyr::filter(event_list, !is.na(.data$video_time)) ## can't have missing video time entries

                vpt <- if (all(pl$type %eq% "youtube")) "youtube" else if (all(pl$type == "local")) "local" else stop("cannot handle playlists of mixed type yet")
                video_player_type(vpt)
                pl
            } else {
                NULL
            }
        })

        ## video stuff
        video_player_type <- reactiveVal("local") ## the current player type, either "local" or "youtube"
        observe({
            if (!is.null(playlist())) {
                ## when playlist() changes, push it through to the javascript playlist
                if (video_player_type() == "local") {
                    js_hide("dvyt_player")
                    js_show("dv_player")
                } else {
                    js_hide("dv_player")
                    js_show("dvyt_player")
                }
                ov_video_control("stop")
                evaljs(ovideo::ov_playlist_as_onclick(playlist(), video_id = if (video_player_type() == "local") "dv_player" else "dvyt_player", dvjs_fun = "dvjs_set_playlist_and_play", seamless = TRUE))
            } else {
                ## empty playlist, so stop the video, and clean things up
                evaljs("dvjs_clear_playlist();")
                ## evaljs("remove_vspinner();") ## doesn't have an effect?
                evaljs("document.getElementById(\"subtitle\").textContent=\"Score\"; document.getElementById(\"subtitleskill\").textContent=\"Skill\";")
            }
        })
        output$player_controls_ui <- renderUI({
            tags$div(tags$button("Play", onclick = "dvjs_video_play();"),
                     tags$button("Prev", onclick = "dvjs_video_prev();"),
                     tags$button("Next", onclick = "dvjs_video_next(false);"),
                     tags$button("Pause", onclick = "dvjs_video_pause();"),
                     tags$button("Back 1s", onclick = "dvjs_jog(-1);"),
                     tags$span(id = "subtitle", "Score"),
                     tags$span(id = "subtitleskill", "Skill")
                     )
        })

        observeEvent(input$playback_rate, {
            if (!is.null(input$playback_rate)) ov_video_control("set_playback_rate", input$playback_rate)
        })

        output$chart_ui <- renderUI(app_data$chart_renderer)

        ## height of the video player element
        vo_height <- reactiveVal("auto")
        observe({
            if (video_player_type() %eq% "youtube") {
                if (!is.null(input$dvyt_height) && as.numeric(input$dvyt_height) > 0) {
                    vo_height(as.numeric(input$dvyt_height))
                    evaljs(paste0("document.getElementById('video_overlay').style.height = '", vo_height(), "px';"))
                } else {
                    vo_height("auto")
                    evaljs(paste0("document.getElementById('video_overlay').style.height = '400px';"))
                }
            } else {
                if (!is.null(input$dv_height) && as.numeric(input$dv_height) > 0) {
                    vo_height(as.numeric(input$dv_height))
                    evaljs(paste0("document.getElementById('video_overlay').style.height = '", vo_height(), "px';"))
                } else {
                    vo_height("auto")
                    evaljs(paste0("document.getElementById('video_overlay').style.height = '400px';"))
                }
            }
        })
        ## width of the video player element
        vo_width <- reactiveVal("auto")
        observe({
            if (video_player_type() %eq% "youtube") {
                if (!is.null(input$dvyt_width) && as.numeric(input$dvyt_width) > 0) {
                    vo_width(as.numeric(input$dvyt_width))
                } else {
                    vo_width("auto")
                }
            } else {
                if (!is.null(input$dv_width) && as.numeric(input$dv_width) > 0) {
                    vo_width(as.numeric(input$dv_width))
                } else {
                    vo_width("auto")
                }
            }
        })
        ## height of the video player container, use as negative vertical offset on the overlay element
        observe({
            if (!is.null(input$vo_voffset) && as.numeric(input$vo_voffset) > 0) {
                evaljs(paste0("document.getElementById('video_overlay').style.marginTop = '-", input$vo_voffset, "px';"))
            } else {
                evaljs("document.getElementById('video_overlay').style.marginTop = '0px';")
            }
        })

        ## panel show/hide
        panel_visible <- reactiveValues(filter2 = FALSE)
        observeEvent(input$collapse_filter2, {
            if (panel_visible$filter2) js_hide("filter2_panel") else js_show("filter2_panel")
            panel_visible$filter2 <- !panel_visible$filter2
        })
        observe({
            if (panel_visible$filter2) updateActionButton(session, "collapse_filter2", label = "Hide") else updateActionButton(session, "collapse_filter2", label = "Show")
        })

    }
}
