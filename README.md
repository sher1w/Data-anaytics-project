 DATA ANALYTICS PROJECT – SPAM MESSAGE CLASSIFIER

OVERVIEW

This project builds a Spam Message Classifier using the Naive Bayes algorithm in R.
The goal of the project is to classify whether a message is **Spam or Not Spam (Ham)** based on the words present in the message.
The model learns patterns from a dataset of messages and then predicts the category of new messages.
Even though Naive Bayes makes a simple assumption that words are independent of each other, it performs **very well for text classification tasks such as spam detection**.

TECHNOLOGIES USED
R Programming
RStudio
Naive Bayes Algorithm
Text Mining

Libraries used:
* tm
* e1071
* caTools


 DATASET
The dataset used contains SMS messages labeled as:
* Spam
* Ham (Normal message)

Each row contains:
* Message label
* Message text

Example:
Spam → "Win a free iPhone now!"
Ham → "Are we meeting today?"



## PROJECT WORKFLOW
1. DATA LOADING
The dataset is loaded using a CSV file.
Only two columns are used:
* label
* message
The labels are converted to **factor type** so that the classifier can work properly.



2. TEXT PREPROCESSING

Before training the model, the text data is cleaned.
The following preprocessing steps are applied:
* Convert all text to lowercase
* Remove numbers
* Remove punctuation
* Remove common stopwords (like *the, is, and*)
* Remove extra whitespace
This helps reduce noise in the dataset.


3. TEXT VECTOR CREATION

The cleaned text is converted into a **Document Term Matrix (DTM).
A Document Term Matrix represents:
* Rows → messages
* Columns → words
* Values → frequency of each word in a message
This allows the machine learning algorithm to work with numerical data.



4. TRAIN TEST SPLIT
The dataset is split into:
80% training data
 20% testing data
The training data is used to build the model and the testing data is used to evaluate its performance.



5. FEATURE TRANSFORMATION
Word frequencies are converted into **Yes/No values**.
Example:
If a word appears in a message →  Yes
If a word does not appear → No
This helps simplify the input for the Naive Bayes classifier.



6. MODEL TRAINING
The Naive Bayes algorithm is used to train the spam classifier.
The model learns the probability of words appearing in spam and non-spam messages.


 7. PREDICTION
The trained model is used to predict whether messages in the test dataset are:
* Spam
* Not Spam



 8. ACCURACY CALCULATION

The performance of the model is measured using  accuracy.
Accuracy is calculated as:
Accuracy = Correct Predictions / Total Predictions
This shows how well the classifier performs on unseen data.



 RESULT
The Naive Bayes classifier is able to successfully classify spam messages based on word patterns.
Even with its simple assumptions, Naive Bayes works effectively for spam filtering problems.



FILES IN THE REPOSITORY

app.R → Shiny application for spam classification
DA.R → R scripts used in the project
Data_analytics.R → Main model implementation
README.md → Project documentation



FUTURE IMPROVEMENTS

Possible improvements include:
* Using larger datasets
* Trying other machine learning algorithms
* Adding better text preprocessing techniques
* Improving the Shiny interface for real-time predictions


It will take like **2 minutes to memorize and makes you look prepared.**
