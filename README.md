
<!-- README.md is generated from README.Rmd. Please edit that file -->

# ovplayer

<!-- badges: start -->

[![lifecycle](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
![openvolley](https://img.shields.io/badge/openvolley-darkblue.svg?logo=data:image/svg%2bxml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyMTAiIGhlaWdodD0iMjEwIj48cGF0aCBkPSJNOTcuODMzIDE4Ny45OTdjLTQuNTUtLjM5Ni0xMi44MTItMS44ODYtMTMuNTgxLTIuNDQ5LS4yNDItLjE3Ny0xLjY5Mi0uNzUzLTMuMjIyLTEuMjgxLTI4LjY5Ni05Ljg5NS0zNS4xNy00NS45ODctMTMuODY4LTc3LjMyMyAyLjY3Mi0zLjkzIDIuNTc5LTQuMTktMS4zOTQtMy45MDYtMTIuNjQxLjktMjcuMiA2Ljk1Mi0zMy4wNjYgMTMuNzQ1LTUuOTg0IDYuOTI3LTcuMzI3IDE0LjUwNy00LjA1MiAyMi44NjIuNzE2IDEuODI2LS45MTgtLjE3LTEuODktMi4zMS03LjM1Mi0xNi4xNzQtOS4xODEtMzguNTYtNC4zMzctNTMuMDc0LjY5MS0yLjA3IDEuNDE1LTMuODY2IDEuNjEtMy45ODkuMTk0LS4xMjMuNzgyLTEuMDUzIDEuMzA3LTIuMDY2IDMuOTQ1LTcuNjE3IDkuNDU4LTEyLjg2MiAxNy44MzktMTYuOTcgMTIuMTcyLTUuOTY4IDI1LjU3NS01LjgyNCA0MS40My40NDUgNi4zMSAyLjQ5NSA4LjgwMiAzLjgwMSAxNi4wNDcgOC40MTMgNC4zNCAyLjc2MiA0LjIxMiAyLjg3NCAzLjU5NC0zLjE3My0yLjgyNi0yNy42ODEtMTYuOTA3LTQyLjE4NS0zNi4wNjgtMzcuMTUxLTQuMjU0IDEuMTE3IDUuMjQtMy4zMzggMTEuNjYtNS40NzMgMTMuMTgtNC4zOCAzOC45MzctNS43NzIgNDYuMDc0LTEuNDg4IDEuMjQ3LjU0NyAyLjIyOCAxLjA5NSAzLjI3NSAxLjYzIDQuMjkgMi4xMDcgMTEuNzMzIDcuNjk4IDE0LjI2NSAxMS40MjcuNDA3LjYgMS4yNyAxLjg2NiAxLjkxNyAyLjgxNCAxMS4zMDggMTYuNTY1IDguNjIzIDQxLjkxLTYuODM4IDY0LjU1Mi0zLjI0OSA0Ljc1OC0zLjI1OCA0Ljc0MiAyLjQ1IDQuMDE4IDMyLjQ4Mi00LjEyMiA0OC41MTUtMjEuOTM1IDM5LjU3OC00My45NzQtMS4xNC0yLjgwOSAxLjU2NiAxLjA2IDMuNTE4IDUuMDMyIDI5LjY5MyA2MC40MTctMjIuNTggMTA3Ljg1My03OS40OTggNzIuMTQzLTUuMDg0LTMuMTktNS4xMjMtMy4xNTItMy45MDIgMy44ODMgNC43MjEgMjcuMjIgMjUuNzgzIDQzLjU2MiA0NC4wODkgMzQuMjEgMS4zNjItLjY5NiAyLjIxLS43NSAyLjIxLS4xNDMtNi43NiAzLjg1Ny0xNi4wMTggNi41NTMtMjMuMTI2IDguMDkxLTcuNTU1IDEuNTQ3LTE4LjM2NiAyLjE3Mi0yNi4wMiAxLjUwNnoiIGZpbGw9IiNmZmYiLz48ZWxsaXBzZSBjeD0iMTA1Ljk3NSIgY3k9IjEwNC40NDEiIHJ4PSI5NC44NCIgcnk9IjkyLjU0MiIgZmlsbD0ibm9uZSIgc3Ryb2tlPSIjZmZmIiBzdHJva2Utd2lkdGg9IjEwLjc0Ii8+PC9zdmc+)
[![R build
status](https://github.com/openvolley/ovplayer/workflows/R-CMD-check/badge.svg)](https://github.com/openvolley/ovplayer/actions)
<!-- badges: end -->

## Installation

You can install from [GitHub](https://github.com/openvolley/ovplayer)
with:

``` r
## install.packages("remotes") ## if needed
remotes::install_github("openvolley/ovplayer")
```

## About

This R package provides a Shiny app for viewing volleyball video
playlists.

At this stage it is entirely experimental. Beware!

## Example usage

``` r
library(ovplayer)
library(ovideo)
## read data file bundled with package
##  this is a very small example file that contains only one rally
x <- datavolley::dv_read(system.file("extdata/190301_kats_beds-clip.dvw", package = "ovplayer"))

## change the video file to point to our local copy, which is bundled with the ovideo package
x$meta$video <- data.frame(camera = "",
                   file = system.file("extdata/2019_03_01-KATS-BEDS-clip.mp4", package = "ovideo"),
                   stringsAsFactors = FALSE)

## extract play-by-play data
px <- datavolley::plays(x)

## normally we would now filter px to the actions we are specifically interested in
## but here we just use all actions because the scout file is only from the one rally
##   that the video covers
px <- px[!is.na(px$skill), ]

## make subtitle columns (shown just underneath the player)
px$subtitle <- px$player_name
px$subtitleskill <- ifelse(px$skill == "Attack", px$attack_code, px$skill)

## build our playlist of these actions
ply <- ov_video_playlist(px, x$meta, extra_cols = c("subtitle", "subtitleskill", "video_time", "code", "set_number", "home_team_score", "visiting_team_score"))

## start the shiny app
ovp_shiny(playlist = ply, video_server = "servr")


## Or the mobile version. This will be served from your laptop/desktop and can
##  be viewed by a mobile device on the same (wifi) network
## You need to know the IP address of your laptop/desktop, we use "192.168.1.21" here

ovp_shiny(playlist = ply, mobile = TRUE, host = "192.168.1.21", video_server = "servr")
## and then go to "192.168.1.21:port" on your mobile to check it out (same wifi), where
##  port is the port being used by the shiny app
```

And you should get something like:

<img src="man/figures/ovplayer.png" style="border: 1px solid black" />
