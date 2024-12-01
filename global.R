##This File only run once on Load.
#All the code added hear only executes once upon initialization of the app
#options(repos = c(CRAN = "https://cran.rstudio.com/", mapttols ="http://R-Forge.R-project.org"))

#setwd("/Users/johnlunalo/Desktop/RLA/RLA Targeting and Layering")

#rsconnect::configureApp("RLATargetingAndLayering",account = "demobi", size="xlarge", server = "shinyapps.io")

library(lubridate) # makes date/time calculations easier
library(ISOweek) # deals with ISO week formatting
library(sf) # understands shape files
#library(ggsn)
library(tidyverse) # general R utilities for data transformation/plotting
library(cowplot) # add on to ggplo2 to make combined plots
library(smoothr) # fill small holes in combined SF plots
library(ggpubr) # for gg paragraph justification rs
library(httr) # for querying data from odin
library(jsonlite) # for querying data from odin
library(scatterpie) # add on for ggplot2 - plot pie chats on maps
library(readxl) # allow for reading excel files
library(shiny)
library(lwgeom)
library(shinyjs)
library(forcats)
library(knitr)
library(DT)
library(png)
library(reshape2)
library(shinyhttr)
library(shinycssloaders)
library(ggspatial)
library(leaflet)
library(grid)
library(plotly)
library(magick)
library(shinyWidgets)
library(rintrojs)
library(bslib)
library(jpeg)
library(AzureAuth)
library(httr)
library(stringr)
library(scales)
require(png)
library(s2)
library(rmarkdown)
library(ggspatial)
library(FluMoDL)
library(ggpmisc)
library(shinyFiles)
library(ggnewscale)
library(RcppRoll) ## Package for a rolling window for summing
library(gt)
sf_use_s2(FALSE)

#Source Themes, Header and Footer files
source(paste0(getwd(), "/rfunctions/AppTheme.R"))
source(paste0(getwd(), "/rfunctions/header.R"))
source(paste0(getwd(), "/rfunctions/footer.R"))


kenya_map0 <- st_read(paste0(getwd(), "/data/shapefiles/gadm41_KEN_0.shp"))
kenya_map1 <- st_read(paste0(getwd(), "/data/shapefiles/gadm41_KEN_1.shp"))
kenya_map2 <- st_read(paste0(getwd(), "/data/shapefiles/gadm41_KEN_2.shp"))
kenya_map3 <- st_read(paste0(getwd(), "/data/shapefiles/gadm41_KEN_3.shp"))

kenya_map0_obj1 <- st_make_valid(kenya_map0)
kenya_map1_obj1 <- st_make_valid(kenya_map1)
kenya_map2_obj1 <- st_make_valid(kenya_map2)
kenya_map3_obj1 <- st_make_valid(kenya_map3)

#preg_sek_activity <- read.csv(paste0(getwd(), "/data/PREG and SEK GIS.csv"))

readRenviron(".env")
post_request <- POST(url = Sys.getenv("url_login"),body = list(email= Sys.getenv("username"), password = Sys.getenv("password") ), encode = "json")

http_error(post_request)
tokens_txt <- content(post_request, as = "text")
tokens_json <- fromJSON(tokens_txt, flatten = TRUE)

access_token = tokens_json$token ;access_token


data_api <- "https://rcp.zedafrica.com/api/activities"
data_inf  <- GET(
  data_api,
  add_headers(authorization = paste0("Bearer ",access_token )
  )
)


###############
data_content_txt <- httr::content(data_inf, as = "text")
data_content_json <- fromJSON(data_content_txt, flatten = TRUE)

preg_sek_activity <- data_content_json$data
preg_sek_activity<- preg_sek_activity[!is.na(preg_sek_activity$id),]
preg_sek_activity<- preg_sek_activity[, 2:13]
preg_sek_activity$Longitude <- as.numeric(preg_sek_activity$Longitude)
preg_sek_activity$Latitude <- as.numeric(preg_sek_activity$Latitude)

#profiles <- read.csv(paste0(getwd(), "/data/profiles.csv"))
#Import Profiles
post_request <- POST(url = Sys.getenv("url_login"),body = list(email= Sys.getenv("username"), password = Sys.getenv("password") ), encode = "json")

http_error(post_request)
tokens_txt <- content(post_request, as = "text")
tokens_json <- fromJSON(tokens_txt, flatten = TRUE)

access_token = tokens_json$token ;access_token


data_api_users <- "https://rcp.zedafrica.com/api/users"
data_inf_users  <- GET(
  data_api_users,
  add_headers(authorization = paste0("Bearer ",access_token )
  )
)

data_content_txt_users <- httr::content(data_inf_users, as = "text")
data_content_json_users <- fromJSON(data_content_txt_users, flatten = TRUE)$data
data_content_json_users$county <- ""

data_content_json_users$created_at <- format(as.Date(stringr::str_sub(data_content_json_users$created_at, start = 1, end = 10), format = "%Y-%m-%d"), "%B %d, %Y")
data_content_json_users <- data_content_json_users[, c("name", "organization_name","organization_type", "email", "phone_number","position","county","list_type", "created_at")]
names(data_content_json_users) <- c("Full Name", "Organization","Organization Type", "Email", "Phone Number","Position", "County","List Type", "Date Created")
profiles <- data_content_json_users


counties_list <- unique(preg_sek_activity$Admin_Name_1)
counties_listp <- unique(profiles$County)
partnerOrg <- unique(preg_sek_activity$Partner_Organization)
partnerOrgp <- unique(profiles$Organization)
orgtypep<- unique(profiles$`Organization Type`)
ProgramStatus <- unique(preg_sek_activity$Activity_Status)

#Load functions
source(paste0(getwd(), "/rfunctions/map.R"))




