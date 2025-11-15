library(tm)
library(e1071)
library(caTools)

# Load dataset
data <- read.csv("C:/Users/Me/Desktop/spam.csv", encoding = "latin1")
data <- data[, 1:2]
colnames(data) <- c("label", "message")

# Convert labels to factor
data$label <- factor(data$label)

# Build corpus
corpus <- VCorpus(VectorSource(data$message))
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("english"))
corpus <- tm_map(corpus, stripWhitespace)

# Document-term matrix
dtm <- DocumentTermMatrix(corpus)

# Split data
set.seed(123)
split <- sample.split(data$label, SplitRatio = 0.8)

train_dtm <- dtm[split == TRUE, ]
test_dtm  <- dtm[split == FALSE, ]

train_labels <- data$label[split == TRUE]
test_labels  <- data$label[split == FALSE]

# Convert counts to Yes/No
convert_counts <- function(x) {
  ifelse(x > 0, "Yes", "No")
}

train_dtm_bin <- apply(train_dtm, 2, convert_counts)
test_dtm_bin  <- apply(test_dtm, 2, convert_counts)

# Train model
model <- naiveBayes(train_dtm_bin, train_labels)

# Predict
pred <- predict(model, test_dtm_bin)

# Accuracy
accuracy <- sum(pred == test_labels) / length(test_labels)
accuracy

