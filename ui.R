
ui = fluidPage(

  #Add a title
  tags$head(tags$link(rel="shortcut icon", href="usaid.png")),

  ## URL title
  tags$title("USAID TARGETTING AND LAYERING PLATFORM"),

  ## theme of the app defined in RFiles/appTheme.R
  theme = appTheme,

  ## header of the app defined in RFiles/header.R
  header,

  tags$head(
    tags$style(HTML("
  #selectionsIDMap {
    justify-content: center;
    align-items: center;
    background-color: #002F6C;
    border-radius: 10px;
    padding: 5px;
    margin-left: 10px;
    margin-right: 10px;
    margin-bottom: 5px;
    color: #FFFFFF;  /* Corrected from font-color to color */
    box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.2);
  }


#secondmenu{
    justify-content: center;
    align-items: center;
    padding: 5px;
    margin-left: 10px;
    margin-right: 10px;
    margin-bottom: 5px;
}

  "))
  ),

  fluidRow(id = "selectionsIDMap",
           column(width = 3,  prettyRadioButtons(inputId = "pagetype",label = "",
                                                 choices = c("Activity map"=1, "User profiles"=2),
                                                 selected = 1, inline = FALSE)),

           column(width = 3,
                  conditionalPanel(condition = "input.pagetype==1",
                  selectInput(inputId = "CountyID", choices = c("All", counties_list), selected = "All", label = "Select county")),

                  conditionalPanel(condition = "input.pagetype==2",
                                   selectInput(inputId = "CountyIDP", choices = c("All", counties_listp), selected = "All", label = "Select county"))

                  ),
           column(width = 3,
                  conditionalPanel(condition = "input.pagetype==1",
                  selectInput(inputId = "PartnerOrgID", choices = c("All", partnerOrg), selected = "All", label = "Select partner organization")),

                  conditionalPanel(condition = "input.pagetype==2",
                                   selectInput(inputId = "PartnerOrgIDP", choices = c("All", partnerOrgp), selected = "All", label = "Select partner organization"))

                  ),
                  column(width = 3,
                         conditionalPanel(condition = "input.pagetype==1",
                         selectInput(inputId = "StatusID", choices = c("All", ProgramStatus), selected = "All", label = "Select program completion status")),

                         conditionalPanel(condition = "input.pagetype==2",
                                          selectInput(inputId = "orgtypep", choices = c("All", orgtypep), selected = "All", label = "Select type of organization"))
                         )

           ),

  conditionalPanel(condition = "input.pagetype==1",

  fluidRow(id = "secondmenu" ,column(offset = 0, width = 4, prettyRadioButtons(inputId = "mapouttype",label = "",
                                                            choices = c("Show static map"=1, "Show leaflet map"=2),
                                                            selected = 2, inline = TRUE)),

           column(width =3,

            conditionalPanel(
                    condition = "input.mapouttype == 2",
            selectInput(
             "cboColorBrewer",
             "Select Color Parlet:",
             choices =
               c(
                 "Accent",
                 "Dark2",
                 "Paired",
                 "Pastel1",
                 "Pastel2",
                 "Set1",
                 "Set2",
                 "Set3",
                 "BrBG",
                 "PiYG",
                 "PRGn",
                 "PuOr",
                 "RdBu",
                 "RdGy",
                 "RdYlBu",
                 "RdYlGn",
                 "Spectral",
                 "Blues",
                 "BuGn",
                 "BuPu",
                 "GnBu",
                 "Greens",
                 "Greys",
                 "Oranges",
                 "OrRd",
                 "PuBu",
                 "PuBuGn",
                 "PuRd",
                 "Purples",
                 "RdPu",
                 "Reds",
                 "YlGn",
                 "YlGnBu",
                 "YlOrBr",
                 "YlOrRd"
               ),
             selected = "Set1"
           ))),



           column(width = 2, offset = 3,downloadButton(outputId = "imagemapdownlaod", label = "Download Map"))),


  conditionalPanel(
    condition = "input.mapouttype == 1",
    fluidRow(
      plotOutput(outputId = "activityMapStatic", height = "600px") %>%
        withSpinner(type = 8, color = "#BA0C2F")
    )
  ),

  conditionalPanel(
    condition = "input.mapouttype == 2",
    fluidRow(
      leafletOutput(outputId = "activityMapLeaf", height = "600px") %>%
        withSpinner(type = 8, color = "#BA0C2F")
    )
  ),


  fluidRow(id = "mapdata",
           dataTableOutput(outputId = "mapdatatable") %>% withSpinner( type = 8, color = "#BA0C2F")),

  br(),
  fluidRow(id = "dnowndatatablefld", column(width = 2, downloadButton(outputId = "maptablecsv",label = "Download table")))),


  conditionalPanel(condition = "input.pagetype==2",

                   fluidRow(
                            dataTableOutput(outputId = "profilestable") %>% withSpinner( type = 8, color = "#BA0C2F")),

                   br(),
                   fluidRow( column(width = 2, downloadButton(outputId = "profilestablecsv",label = "Download table")))

  ),

  br(),

  footer
)
