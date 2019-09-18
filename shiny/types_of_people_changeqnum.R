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

# Define UI for dataset viewer app ----
ui <- fluidPage(
    
    # App title ----
    titlePanel("Survey Data"),
    
    # Sidebar layout with input and output definitions ----
    sidebarLayout(
        
        # Sidebar panel for inputs ----
        sidebarPanel(
            
            # Input: Choose the sample size ----
            sliderInput("obs", 
                         label = h3("Select the sample size:"),
                         value = 10,
                         min = 1,
                         max = 100),
            
            hr(),
            fluidRow(column(3, verbatimTextOutput("value"))),
            
            # Input: Choose the sample size ----
            sliderInput("qs", 
                         label = h3("Choose the number of questions:"),
                         value = 1,
                         min = 1,
                         max = 5,
                         step= 1),
            
            # Include clarifying text ----
            helpText("Food for thought:
                     If you ask 2 questions, what is the maximum number of possible personality types you could observe? What is the smallest sample size at which you observe that number of distinct personality types? How do the answers to these questions change if you ask 3 questions? 4 questions? 5 questions?")
            
        ),
        
        # Main panel for displaying outputs ----
        mainPanel(
            
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
                       Q2=sample(c("C", "D"), 100, prob=c(.3,.7), replace=T),
                       Q3=sample(c("E", "F"), 100, prob=c(.6,.4), replace=T),
                       Q4=sample(c("G", "H"), 100, prob=c(.5,.5), replace=T),
                       Q5=sample(c("I", "J"), 100, prob=c(.8,.2), replace=T))
    data$type <- apply(data, 1, paste, collapse="")
    row.names(data) <- paste0("student",1:100)
    colnames(data) <- c(paste0("Q",1:5), "Personality Type")

    output$barplot <- renderPlot({
        data2 <- data[1:input$obs,1:input$qs,drop=F]
        data2$type <- apply(data2, 1, paste, collapse="")
        colnames(data2) <- c(paste0("Q",1:input$qs), "Personality Type")
        unique <- length(unique(data2$`Personality Type`))
        if(unique == 1){
            unique <- 2
        }
        labsize <- (1/(.1+log(unique)))*2
        # Render a barplot
        barplot(table(data2[1:input$obs,"Personality Type"]), 
                main="Frequency of Personality Types",
                ylab="Number of Students",
                xlab="Personality Type",
                cex.names = labsize)
    })
    
    # Show the first "n" observations ----
    output$view <- renderTable({
        data2 <- data[,1:input$qs,drop=F]
        data2$type <- apply(data2, 1, paste, collapse="")
        colnames(data2) <- c(paste0("Q",1:input$qs), "Personality Type")
        head(data2, n = input$obs)},
        rownames=TRUE)
    
}

# Create Shiny app ----
shinyApp(ui, server)
