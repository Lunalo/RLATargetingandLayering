server = function(input, output, session) {

  output$activityMapStatic <- renderPlot({plot(statitic_map())})
  output$activityMapLeaf <- renderLeaflet({leaflet_map()})

  statitic_map1 <- eventReactive(
    {input$CountyID; input$PartnerOrgID; input$StatusID; input$mapouttype;input$pagetype},{
    activitymap_out <- activitymap(county = input$CountyID,
                                    IP = input$PartnerOrgID,
                                    status = input$StatusID)

    return(activitymap_out)
  })


  statitic_map <- reactive({
    return(statitic_map1())
  })



  leaflet_map1 <- eventReactive(c(input$CountyID,input$PartnerOrgID, input$StatusID, input$cboColorBrewer),{

    if(nrow(mapdownout1())>1){

      activitymapleaf_out <- map_leaflet(county = input$CountyID,
                                         IP = input$PartnerOrgID,
                                         status = input$StatusID, parlette =  input$cboColorBrewer)

      return(activitymapleaf_out)

    }else{

      leaf1 <- leaflet() %>%
        addTiles(group = "OSM",options = providerTileOptions(opacity = 1)) %>%
        addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron")%>%
        addLayersControl(baseGroups= c("OSM","CartoDB.Positron"))

      showModal(modalDialog(
        h2("Data not available!"),
        style = "text-align: center;color: red",
        p("Click on Close button and do another selection"),
        footer = tagList(
          actionButton("dismissBtn", "Close")
        )
      ))

      return(leaf1)
    }

  })



  observeEvent(input$dismissBtn, {
    removeModal()
  })


  leaflet_map <-reactive({leaflet_map1()})


  mapdownout1 <- eventReactive({input$CountyID; input$PartnerOrgID; input$StatusID; input$mapouttype;input$pagetype},{
    df1 <- preg_sek_activity
    county_name <- input$CountyID
    implementing_partner <- input$PartnerOrgID
    status_name <- input$StatusID

    if(county_name =="All"){
      df1 = df1
    } else{
      df1= df1%>%filter(Admin_Name_1%in%county_name)
    }


    if(implementing_partner =="All"){
      df1= df1
    }else{
      df1= df1%>%filter(Partner_Organization%in%implementing_partner)
    }

    if(status_name =="All"){
      df1= df1
    }else{
      df1= df1%>%filter(Intervention_Status%in%status_name)
    }

    return(df1)
  })


  mapdownout<- reactive({mapdownout1()})



  proftable1 <- eventReactive(c(input$PartnerOrgIDP,input$CountyIDP, input$orgtypep),{
    df1 <- profiles
    county_name <- input$CountyID
    implementing_partner <- input$PartnerOrgID
    orgtype <- input$orgtypep

    if(county_name =="All"){
      df1 = df1
    } else{
      df1= df1%>%filter(County%in%county_name)
    }





    if(implementing_partner =="All"){
      df1= df1
    }else{
      df1= df1%>%filter(Organization%in%implementing_partner)
    }

    if(orgtype =="All"){
      df1= df1
    }else{
      df1= df1%>%filter(Organization.Type%in%orgtype)
    }

    return(df1)
  })

  proftable <- reactive({proftable1()})

  output$mapdatatable <- renderDataTable({
    DT::datatable(mapdownout(),
                  filter = "top", extensions = c("Scroller"),
                  options = list(
                    searching = TRUE,
                    paging = TRUE,
                    info = FALSE)
                  ,
                  rownames = FALSE)
  })


  output$maptablecsv <- downloadHandler(
    filename = function() {
        paste0("Preg SEK Data.csv")
    },
    content = function(file) {
        write.csv(mapdownout(),
                  file = file)
      }

  )



  output$imagemapdownlaod <- downloadHandler(
    filename = function() {
      paste0("Preg_map_genereated.png")
    },

    content = function(file) {
      showModal(
        modalDialog(
          style = "text-align: center;",
          h2("Please Wait!"),
          p("Map is being prepared. It will be downloaded soon."),
          footer = NULL
        )
      )

      # Choose file format based on radio button input
      if (input$mapouttype == 1) {
        ggsave(file, plot = statitic_map(), device = "jpeg", width = 16, height = 9)

      } else {
        ggsave(file, plot = statitic_map(), device = "jpeg", width = 16, height = 9)


      }

      removeModal()
    }

  )






  output$profilestable <- renderDataTable({
    DT::datatable(proftable(),
                  filter = "top", extensions = c("Scroller"),
                  options = list(
                    searching = TRUE,
                    paging = TRUE,
                    info = FALSE)
                  ,
                  rownames = FALSE)
  })


  output$profilestablecsv <- downloadHandler(
    filename = function() {
      paste0("UserProfiles.csv")
    },
    content = function(file) {
      write.csv(proftable(),
                file = file)
    }

  )



}
