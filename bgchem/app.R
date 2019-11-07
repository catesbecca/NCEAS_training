#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(rsconnect)


#Load data from arctic data center

bgchem <- read.csv(url("https://arcticdata.io/metacat/d1/mn/v2/object/urn%3Auuid%3A35ad7624-b159-4e29-a700-0c0770419941", method="libcurl"), stringsAsFactors = FALSE)
names(bgchem)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Water Biogeochemistry Data"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("depth",
                        "Depth:",
                        min = 1,
                        max = 500,
                        value = c(1, 100))
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot"),
           plotOutput("secondplot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) 
    
    {
    output$distPlot <- renderPlot({
        ggplot(bgchem, mapping = aes(x=CTD_Depth, y = CTD_Salinity))+
            geom_point(size=3, color="red")+
            xlim(input$depth[1], input$depth[2])+
            theme_light()
        
    })
    
    output$secondplot <- renderPlot({
        ggplot(bgchem, mapping = aes(x=CTD_Depth, y = CTD_Temperature))+
            geom_point(size=3, color="red")+
            xlim(input$depth[1], input$depth[2])+
            theme_light()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
