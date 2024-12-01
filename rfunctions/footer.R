footer =   list(
  tags$style(HTML("
      .footer {
        background-color: #002F6C;
        color: white;
        padding: 10px;
        text-align: center;
       }
      .footer a {
        margin: 0px;
        color: white;
      }
      .footer a:hover {
        color:  #651D32;
      }
      .footer .social-icon {
        font-size: 24px;
        margin: 5px;
        color: white;
      }
      .footer .social-icon:hover {
        color:  #651D32;
      }
    ")),
  fluidRow(
    wellPanel(
      style = "background: #002F6C; border-radius: 0px;",
      column(
        width = 12,
        div(
          class = "footer",
          fluidRow(
            column(
              width = 12,
              br(),
              HTML(paste0("© ", year(Sys.Date()), " Resilience Learning Activity. Some Rights Reserved.")),br(),br(),
              HTML('<em>This Knowledge Management Hub is facilitated by the Resilience Learning Activity, that is USAID funded. For the Partnership for Resilience and Economic Growth (PREG), RLA is the is the secretariat and the leading learning partner. The information provided on this Web site is not official U.S. Government information and does not represent the views or positions of the U.S. Agency for International Development (USAID) or the U.S. Government.</em>')
            )
          )
        )
      )
    )))

