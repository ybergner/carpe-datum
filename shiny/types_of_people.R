#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

if(!require(shiny)) {
    install.packages("shiny")
}
library(shiny)

# Define UI for dataset viewer app ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Survey Data"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Choose the sample size ----
            numericInput("obs", 
                         label = h3("Choose any sample size between 1 and 100"),
                         value = 10,
                         min = 1,
                         max = 100),
            
            hr(),
            fluidRow(column(3, verbatimTextOutput("value"))),
            
            # Include clarifying text ----
            helpText("Food for thought: What is the smallest sample size for which you still observe 4 distinct personality types? Three distinct types? Based on 25 responses, do you think personality type AA or BA is more common? Which do you think is more common based on 40 responses?")
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
            # Output: Header + summary of data ----
            h4("Table of Responses"),
            verbatimTextOutput("summary"),
            
            h4("Bar Plot of Personality Types"),
            plotOutput("barplot"),
            
            # Output: Header + table of distribution ----
            h4("Response Data"),
            tableOutput("view")
        )
        
    )
)

# Define server logic to summarize and view selected dataset ----
server <- function(input, output) {
    
    # Generate some data
    set.seed(333)
    data <- data.frame(Q1=sample(c("A", "B"), 100, prob=c(.5,.5), replace=T),
                       Q2=sample(c("A", "B"), 100, prob=c(.3,.7), replace=T))
    data$type <- paste0(data$Q1,data$Q2)
    row.names(data) <- paste0("student",1:100)
    colnames(data) <- c("Q1 Response", "Q2 Response", "Personality Type")

    # Generate a summary of the dataset ----
    output$summary <- renderPrint({
        table(data[1:input$obs,1:2])
    })
    
    output$barplot <- renderPlot({
        
        # Render a barplot
        barplot(table(data[1:input$obs,3]), 
                main="Frequency of Personality Types",
                ylab="Number of Students",
                xlab="Personality Type")
    })
    
    # Show the first "n" observations ----
    output$view <- renderTable({
        head(data, n = input$obs)},
        rownames=TRUE)
    
}

# Create Shiny app ----
shinyApp(ui, server)
