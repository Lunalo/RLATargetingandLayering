header = list(
  tags$head(
    tags$style(
      HTML("
        .header {
          background: #FFFFF;
          color: #002F6C;
          padding: 10px;
          display: flex;
          align-items: center;
       }

       hr {
          color: #BA0C2F !important;
          border-width: 2px !important;
          border-color: #BA0C2F !important;
          border-style: solid !important;
          }

        .logo {
          flex-shrink: 0;
          margin-right: 20px;
          max-height: 90%;
          max-width: 90%;
        }

        .header-text h1 {
          font-size: 30px;
          font-weight: bold;
          text-align:center;
          align-items: center;
        }


        .header-text1 h2 {
          font-size: 20px;
          font-weight: bold;
          text-align: right;
          align-items: right;
        }

        .header-text h3 {
          font-size: 20px;
        }
      ")
    )
  ),
  fluidRow(
    id = "nomoveheader",
    column(
      width = 2,
      class = "header",
      img(
        src = "usaid.png",
        class = "logo"
      )
    ),
    column(
      width = 7,
      class = "header",
      div(
        class = "header-text",
        h1("USAID TARGETTING AND LAYERING PLATFORM"),
      )
    ),
    column(width = 3,
           class = "header",
           div(
             class = "header-text1",
             h2(paste0(format(Sys.Date(), "%B %d, %Y")))
           )
    ),
    hr()
  )
)
