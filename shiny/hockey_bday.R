#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#download/load shiny
if(!require(shiny)) {
    install.packages("shiny")
}
library(shiny)
if(!require(ggplot2)) {
    install.packages("ggplot2")
}
library(dplyr)
if(!require(dplyr)) {
    install.packages("dplyr")
}
library(dplyr)
# Define UI for dataset viewer app ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Hockey Birthdays"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            numericInput("Q1Prob", "Probability of a Q1 Bday(%)", value=0, min=0, max=50),
            numericInput("Q4Prob", "Probability of a Q4 Bday(%)", value=0, min=0, max=50),
            actionButton("resample", "Re-Sample"),
            actionButton("observed", "Observed Data"),
            
            
            # Include clarifying text ----
            helpText("Use the inputs above to change the probability that a given hockey player has a 1st (Jan-March) or 4th (Oct-Dec) quarter birthday. This app will then take 33 samples of 100 players (100 people per year for each year from 1978-2011)  
                     and plot the simulated number of individuals with Q1 and Q4 birthdays. These will be plotted in the graph on the top right. You can also click the Re-Sample button if you want to take a new set of 33 samples. Click on the Observed Data button to view the actual data" )
            
        ),
        
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            h4("Plot of Simulated 1st and 4th Quarter Bdays"),
            plotOutput("scatterplot",width  = "500px",height = "350px"),
            
            br(),
            br(),
            
            conditionalPanel("input.observed",
            h4("Plot of Observed 1st and 4th Quarter Bdays"),
            img(src='True_Plot.png', width  = "650px",height = "375px")
            )

            
        )
        
    )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output,session) {
    
    #This was from when I allowed max prob=100% for both and wanted to make sure the total
    #didn't exceed 100% for Q1 and Q4. For full functionality, would have to do same for Q1Prob.
    
    # observeEvent(input$Q1Prob, {
    #     
    #     x <- input$Q1Prob
    #     updateNumericInput(session, "Q4Prob", max = 100-x)
    # 
    # })
    
    

    output$scatterplot <- renderPlot({
        input$resample
        # Get draft data (33 samples of 100)
        Q1 <- input$Q1Prob/100
        Q4 <- input$Q4Prob/100
        Q2 <- Q3 <- (1-(Q1+Q4))/2
        draftdata <- rmultinom(33,100,c(Q1,Q2,Q3,Q4))
        plot(draftdata[1,], pch=17, col=c("#FFFF00"), ylab="Percentage drafted", 
             xlab="", ylim=c(0,60), xlim=c(0,ncol(draftdata)+1), xaxt="n", 
             xaxs="i",yaxs="i", bty="l", tck = 0.02, cex.lab=1.5)
        points(1:ncol(draftdata), draftdata[1,], pch=2, cex=1.5)
        points(1:ncol(draftdata), draftdata[4,], pch=16, col="#04B0F0", cex=1.5)
        points(1:ncol(draftdata), draftdata[4,], pch=1, cex=1.5)
        axis(1, at=c(0,10,20,30), labels = c(1978,1988,1998,2008), tck = 0.02, cex.axis=1.3)
        legend("topright", c("Q1", "Q4"), col=c("#FFFF00","#04B0F0"), pch=c(17,16), bty = "n", cex=1.2)
        legend("topright", c("Q1", "Q4"), pch=c(2,1), bty="n", cex=1.2)
    })
  
    
}

# Create Shiny app ----
shinyApp(ui, server)
