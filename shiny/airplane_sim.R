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
    titlePanel("Airplane Seat Simulation"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            sliderInput("prob", 
                         "Percent Chance of an Individual Showing Up", 
                         value=95, 
                         min=1, 
                         max=100),
            sliderInput("tixcost", 
                         "Cost per Ticket", 
                         value=50, 
                         min=0, 
                         max=100),
           sliderInput("payout", 
                         "Pay Out per Person to Switch", 
                         value=50, 
                         min=0, 
                         max=100),
           sliderInput("numtix", 
                         "Number of tickets sold", 
                         value=100, 
                         min=0, 
                         max=200),
           actionButton("runonce", "Run Once"),
           actionButton("run100", "Run 100 Times"),
         
            
            # Include clarifying text ----
            helpText("Use the above inputs to change the percent chance that any individual shows up, the cost per ticket, the pay out by airlines to anyone who has to switch planes, and the number of tickets to sell per plane (assuming that each plane has 100 seats). Run once to see the airline's net profit or loss for one plane and run 100 times to see net profit or loss over 100 flights." )
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
           h4("Run Similation 100 Times:"),
           plotOutput("hist"),
           textOutput("result1"),
           
            
           h4("Run Simulation Once:"),
           textOutput("result2")
            
            
        )
        
    )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output,session) {
    
    observeEvent(input$runonce, {
        if(input$numtix>=100){
            x <- sample(c(0,1),
                        size=input$numtix,
                        prob=c(1-(input$prob/100), input$prob/100),
                        replace=TRUE)
            y <- 100 - sum(x)
            if(y>=0){
                output$result2 <- renderText({
                    paste("The airline sold", input$numtix, "tickets at $",input$tixcost, "per ticket. Only", sum(x), "people showed up to the flight. The airline made ", 
                          (input$numtix-100)*input$tixcost, 
                          "dollars on this flight.")
                })   
            }
            if(y<0){
                output$result2 <- renderText({
                    paste("The airline sold", input$numtix, "tickets at $",input$tixcost, "per ticket.", sum(x), "people showed up to the flight, so the airline had to pay out $", y-100, ".The airline lost", 
                          abs(y)*input$payout, 
                          " dollars on this flight.")
                })   
            }
        }
        else if(input$numtix==100){
            output$result2 <- renderText({
                paste("The airline made $0 on this flight.")
            })
        }
        else if(input$numtix<100){
            output$result2 <- renderText({
                paste("The airline lost $", 
                      (100-input$numtix)*input$tixcost, 
                      " on this flight.")
            })
        }

    })
    
    observeEvent(input$run100, {
        if (input$numtix>=100){
            x <- rep(NA,100)
            for(i in 1:100){
                x[i] <- 100-sum(
                            sample(c(0,1),
                            size=input$numtix,
                            prob=c(1-(input$prob/100), input$prob/100),
                            replace=TRUE))
                if(x[i]<0){
                    x[i] <- input$payout*x[i]
                }
                else if(x[i]>=0){
                    x[i] <- (input$numtix-100)*input$tixcost
                }
            }
            
            if(sum(x)>=0){
                output$result1 <- renderText({
                    paste("The airline made $", 
                          sum(x), 
                          " overall on these 100 flights.")
                }) 
            }
            
            if(sum(x)<0){
                output$result1 <- renderText({
                    paste("The airline lost $", 
                          abs(sum(x)), 
                          " overall on these 100 flights.")
                }) 
            }
            
            output$hist <- renderPlot({
                barplot(table(x), 
                     xlab="Net Gains or Losses", 
                     ylab="Proportion of Flights",
                     main="Bar Plot of Net Gains/Losses per Flight",
                     col=(unique(x)[order(unique(x))]>=0)+2)
                     #abline(v=0,col="red", lwd=3)
            })
        }
        else if(input$numtix<=100){
            output$result1 <- renderText({
                paste("The airline lost", 
                      (100-input$numtix)*input$tixcost*100, 
                      " dollars overall on these 100 flights")
            })
            output$hist <- renderPlot({
                barplot(table(rep((100-input$numtix)*input$tixcost,100)), 
                     xlab="Net Gains or Losses", 
                     ylab="Proportion of Flights",
                     main="Bar Plot of Net Gains/Losses per Flight",
                     col=(unique(x)[order(unique(x))]>=0)+2)
                     #abline(v=0,col="red", lwd=3)
            })
        }
        
    })
    
    
}

# Create Shiny app ----
shinyApp(ui, server)
