#' Example playlists
#'
#' @param choice numeric: which data file to return?
#' \itemize{
#'   \item{1 - Pipe attacks by Poland in the Poland - Iran men's World League match, June 2017}
#' }
#' @return A data.frame containing the playlist.
#'
#' @seealso \code{\link{ovp_shiny}}
#'
#' @examples
#' \dontrun{
#'  ## read example playlist
#'  ply <- ovp_example_playlist(1)
#'
#'  ## start shiny app
#'  ovp_shiny(playlist = ply)
#' }
#'
#' @export
ovp_example_playlist <- function(choice) {
    assert_that(is.numeric(choice))
    switch(as.character(choice),
           "1" = {
tribble(~video_src, ~start_time, ~duration, ~type, ~seamless_start_time, ~seamless_duration, ~subtitle, ~subtitleskill, ~home_team, ~visiting_team, ~video_time, ~code, ~set_number, ~home_team_score, ~visiting_team_score, ~file,
"NisDpPFPQwU",  589, 8, "youtube",  589, 8,   "Set 1 - POLAND 2017 9 - 7 Iran 2017", "Michal KUBIAK - Pipe : - POLAND 2017 Iran 2017", "Poland", "Iran",  594, "*13AM-XP~83~H1", 1,  9,  7, NA_character_,
"NisDpPFPQwU", 1036, 8, "youtube", 1036, 8, "Set 1 - POLAND 2017 17 - 10 Iran 2017", "Michal KUBIAK - Pipe : # POLAND 2017 Iran 2017", "Poland", "Iran", 1041, "*13AM#XP~86~H1", 1, 17, 10, NA_character_,
"NisDpPFPQwU", 1163, 8, "youtube", 1163, 8, "Set 1 - POLAND 2017 19 - 12 Iran 2017", "Michal KUBIAK - Pipe : # POLAND 2017 Iran 2017", "Poland", "Iran", 1168, "*13AM#XP~82~H1", 1, 19, 12, NA_character_,
"NisDpPFPQwU", 2731, 8, "youtube", 2731, 8, "Set 2 - POLAND 2017 12 - 12 Iran 2017", "Rafal BUSZEK - Pipe : =  POLAND 2017 Iran 2017", "Poland", "Iran", 2736, "*21AM=XP~86~H1", 2, 12, 12, NA_character_,
"NisDpPFPQwU", 4594, 8, "youtube", 4594, 8,  "Set 3 - POLAND 2017 10 - 9 Iran 2017", "Michal KUBIAK - Pipe : # POLAND 2017 Iran 2017", "Poland", "Iran", 4599, "*13AM#XP~83~H1", 3, 10,  9, NA_character_)
           },
           stop("unrecognized 'choice' value (", choice, ")")
           )
}
