
source(paste0(getwd(),"/global.R"))
source(paste0(getwd(),"/ui.R"))
source(paste0(getwd(),"/server.R"))

# Run the app
shinyApp(ui = ui, server = server)