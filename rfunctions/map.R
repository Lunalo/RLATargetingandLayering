activitymap = function(
    df = preg_sek_activity,
    kenya_map0_obj = kenya_map0_obj1,
    kenya_map1_obj = kenya_map1_obj1,
    kenya_map2_obj = kenya_map2_obj1,
    kenya_map3_obj = kenya_map3_obj1,
    county = "All",
    IP = "All",
    status = "All"

){


  df1 <- df
  county_name <- county
  implementing_partner <- IP
  status_name <- status

  if(county_name =="All"){
    kenya_map0_obj <- kenya_map0_obj
    kenya_map1_obj <- kenya_map1_obj
    kenya_map2_obj <- kenya_map2_obj
    kenya_map3_obj <- kenya_map3_obj
    df1 <- df1
  } else{
    kenya_map0_obj <- kenya_map0_obj
    kenya_map1_obj <- kenya_map1_obj%>%filter(NAME_1 %in%county_name)
    kenya_map2_obj <- kenya_map2_obj%>%filter(NAME_1 %in%county_name)
    kenya_map3_obj <- kenya_map3_obj%>%filter(NAME_1 %in%county_name)
    df1<- df1%>%filter(Admin_Name_1%in%county_name)
  }


  if(implementing_partner =="All"){
    df1<- df1
  }else{
    df1<- df1%>%filter(Partner_Organization%in%implementing_partner)
  }

  if(status_name =="All"){
    df1<- df1
  }else{
    df1<- df1%>%filter(Intervention_Status%in%status_name)
  }

if(county_name=="All"){
  map_fig <- ggplot() +
    geom_sf(data = kenya_map3_obj, col = "#A9A9A9", linetype = "solid",fill = NA, lwd=.1)+
    geom_sf(data = kenya_map0_obj, col = "black",linetype = "solid", fill = NA, lwd =1) +
    geom_sf(data = kenya_map1_obj, col = "black", linetype = "solid",fill = NA, lwd= .5) +
    #geom_sf(data = kenya_map2_obj, col = "black", linetype = "solid",fill = NA, lwd = .7) +
    geom_point(data = df1, aes(x = Longitude, y = Latitude,fill = Partner_Organization), size = 2,
               shape = 23)
}else{
  map_fig <- ggplot() +
    geom_sf(data = kenya_map3_obj, col = "#A9A9A9", linetype = "solid",fill = NA, lwd=.1)+
    geom_sf(data = kenya_map1_obj, col = "black", linetype = "solid",fill = NA, lwd= 1) +
    geom_point(data = df1, aes(x = Longitude, y = Latitude,fill = Partner_Organization), size = 2,
               shape = 23)
}

  map_fig <- map_fig +
    xlab("") +
    ylab("")+theme_minimal()+
    theme(legend.position = "right",
          legend.text = element_text(size = 8, color = "black", face = "bold"),
          legend.title = element_text(size = 12, color = "black", face = "bold"),
          axis.text = element_blank(), axis.title = element_blank(),
          panel.grid.major = element_blank(),
          panel.grid.minor = element_blank()

    )+
    guides(fill = guide_legend(ncol = 1, title = "Partner Organizations"))


  return(map_fig)

}

#Test
#activitymap()

###############Leaflet

map_leaflet <- function(df = preg_sek_activity,
                        county = "All",
                        IP = "All",
                        status = "All",
                        parlette= "Set1"){




  df1 <- df
  county_name <- county
  implementing_partner <- IP
  status_name <- status

  if(county_name =="All"){
    kenya_map0_obj1 = kenya_map0_obj1
    kenya_map1_obj1 = kenya_map1_obj1
    kenya_map2_obj1 = kenya_map2_obj1
    kenya_map3_obj1 = kenya_map3_obj1
    df1 = df1
  } else{
    kenya_map0_obj1 = kenya_map0_obj1
    kenya_map1_obj1 = kenya_map1_obj1%>%filter(NAME_1 %in%county_name)
    kenya_map2_obj1 = kenya_map2_obj1%>%filter(NAME_1 %in%county_name)
    kenya_map3_obj1 = kenya_map3_obj1%>%filter(NAME_1 %in%county_name)
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




  df1$marker_label <-  paste0("<style>
                              .labpop {
                                background-color: #BA0C2F;
                                border-color: #BA0C2F;
                                color: white;
                                padding: 0px;
                                margin: 0;
                                }
                              </style><p class='labpop'>","<br>", "<strong>",
                             "Activity Details", "</strong>", "</b>","<br/>", "<br>",
                             "Activity Name: ", df1$Activity_Name, "<br/>",
                             "Partner Organization: ", df1$Partner_Organization,"<br/>",
                             "Activity Status: ", df1$Activity_Status,"<br/>",
                             "Specific Intervention: ", df1$Intervention_Description,"<br/>",
                             "County: ", df1$Admin_Name_1,"<br/>",
                             "Sub county: ", df1$Admin_Name_2, "</p>")

  leaf1 <- leaflet() %>%
    addTiles(group = "OSM",options = providerTileOptions(opacity = 1)) %>%
    addProviderTiles("CartoDB.Positron", group = "CartoDB.Positron")%>%
    addLayersControl(baseGroups= c("OSM","CartoDB.Positron"))
    #addPolygons(data = kenya_map3_obj1, color="black", fillColor = "black",fillOpacity= 0 ,weight = 1) %>%
   # addPolygons(data = kenya_map1_obj1, color="black", fillColor = "black",fillOpacity= 0 ,weight = 2)

  #if(county_name =="All"){
    #leaf1 <- leaf1%>%addPolygons(data = kenya_map0_obj1, color="black", fillColor = "black",fillOpacity= 0 ,weight = 3)
  #}

  if(nrow(df1)>0){
    palette=  colorRampPalette(RColorBrewer::brewer.pal(9, parlette))(length(unique(df1$Partner_Organization)))

    palProjects = colorFactor(palette, levels = unique(df1$Partner_Organization))
    marker_label_1 <- df1$marker_label%>%lapply(htmltools::HTML)
    leaf1<- leaf1%>%addCircleMarkers(
      data = df1,
      lng = ~Longitude,
      lat = ~Latitude,
      radius = 2,
      color =~palProjects(Partner_Organization),
      fill = ~palProjects(Partner_Organization),
      opacity = 1,
      fillOpacity = 0.5,
      label = marker_label_1,
      popup =  marker_label_1
    )%>%
      addScaleBar(position = "bottomright") %>% fitBounds(min(min(df1$Longitude)), min(max(df1$Latitude)),
                                                          max(max(df1$Longitude)), max(min(df1$Latitude)))%>%
      leaflet.extras::addResetMapButton()

  }

 leaf1


}


#map_leaflet()
