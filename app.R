# ------------------- LIBRARIES ----------------------
library(shiny)
library(shinydashboard)
library(tm)
library(e1071)
library(caTools)

# ------------------ LOAD & TRAIN MODEL ---------------------

data <- read.csv("C:/Users/Me/Desktop/spam.csv", encoding = "latin1")
data <- data[, 1:2]
colnames(data) <- c("label", "message")
data$label <- factor(data$label)

corpus <- VCorpus(VectorSource(data$message))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

dtm <- DocumentTermMatrix(corpus)

set.seed(123)
split <- sample.split(data$label, SplitRatio = 0.8)

train_dtm <- dtm[split == TRUE, ]
test_dtm  <- dtm[split == FALSE, ]

train_labels <- data$label[split == TRUE]
test_labels  <- data$label[split == FALSE]

convert_counts <- function(x) {
  ifelse(x > 0, "Yes", "No")
}

train_dtm_bin <- apply(train_dtm, 2, convert_counts)
test_dtm_bin  <- apply(test_dtm, 2, convert_counts)

model <- naiveBayes(train_dtm_bin, train_labels)

pred <- predict(model, test_dtm_bin)
accuracy <- sum(pred == test_labels) / length(test_labels)

# ------------------ SHINY UI -----------------------------

ui <- dashboardPage(
  
  dashboardHeader(title = "Spam Classifier Dashboard"),
  
  dashboardSidebar(
    sidebarMenu(
      menuItem("Dashboard", tabName = "dash", icon = icon("dashboard")),
      menuItem("View Data", tabName = "data", icon = icon("table")),
      menuItem("Spam Classifier", tabName = "spam", icon = icon("envelope"))
    )
  ),
  
  dashboardBody(
    tabItems(
      
      # ---------------- DASHBOARD TAB ----------------
      tabItem(tabName = "dash",
              fluidRow(
                valueBoxOutput("accBox"),
                valueBoxOutput("spamCount"),
                valueBoxOutput("hamCount")
              ),
              
              fluidRow(
                box(width = 6, title = "Spam vs Ham Pie Chart", status = "primary",
                    plotOutput("pieChart")),
                box(width = 6, title = "Dataset Summary",
                    verbatimTextOutput("dataSummary"))
              )
      ),
      
      # ---------------- VIEW DATA TAB ----------------
      tabItem(tabName = "data",
              fluidRow(
                box(width = 12, title = "Dataset",
                    dataTableOutput("table"))
              )
      ),
      
      # ---------------- SPAM CLASSIFIER TAB ----------------
      tabItem(tabName = "spam",
              textInput("user_msg", "Enter a message:", ""),
              actionButton("classify_btn", "Classify"),
              h3("Prediction:"),
              verbatimTextOutput("prediction")
      )
    )
  )
)

# ------------------ SERVER --------------------------------

server <- function(input, output) {
  
  # ---------------- VALUE BOXES ----------------
  output$accBox <- renderValueBox({
    valueBox(
      paste0(round(accuracy * 100, 2), "%"),
      "Model Accuracy",
      icon = icon("check-circle"),
      color = "green"
    )
  })
  
  output$spamCount <- renderValueBox({
    valueBox(sum(data$label == "spam"), "Spam Messages", icon = icon("exclamation-triangle"), color = "red")
  })
  
  output$hamCount <- renderValueBox({
    valueBox(sum(data$label == "ham"), "Ham Messages", icon = icon("message"), color = "blue")
  })
  
  # ---------------- PIE CHART ----------------
  output$pieChart <- renderPlot({
    counts <- table(data$label)
    pie(counts, col = c("red", "green"), main = "Spam vs Ham Distribution")
  })
  
  # ---------------- DATA SUMMARY ----------------
  output$dataSummary <- renderPrint({
    summary(data)
  })
  
  # ---------------- TABLE VIEW ----------------
  output$table <- renderDataTable({
    data
  })
  
  # ---------------- MESSAGE CLASSIFICATION ----------------
  observeEvent(input$classify_btn, {
    req(input$user_msg)
    
    new_msg <- input$user_msg
    
    new_corpus <- VCorpus(VectorSource(new_msg))
    new_corpus <- tm_map(new_corpus, content_transformer(tolower))
    new_corpus <- tm_map(new_corpus, removeNumbers)
    new_corpus <- tm_map(new_corpus, removePunctuation)
    new_corpus <- tm_map(new_corpus, removeWords, stopwords("english"))
    new_corpus <- tm_map(new_corpus, stripWhitespace)
    
    new_dtm <- DocumentTermMatrix(new_corpus, control = list(dictionary = Terms(train_dtm)))
    new_bin <- apply(new_dtm, 2, convert_counts)
    
    prediction <- predict(model, new_bin)
    
    output$prediction <- renderPrint({
      paste("This message is classified as:", as.character(prediction))
    })
  })
}

# ---------------- RUN APP -----------------------------
shinyApp(ui, server)
