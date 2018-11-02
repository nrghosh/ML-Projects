# Part 1: Data Prep
# load("/Users/nikhilghosh/Desktop/DM:ML/asgn5/heart.rdata")
set.seed(1234)
index <- sample(nrow(heart), 0.75*nrow(heart))
train <- heart[index,]
test <- heart[-index,]


# Part 2: Support Vector Machine
# A binary classification model that uses a clustering algorithm (developed by Siegelmann and Vapnik)
# This model works by carefully constructing a hyperplane or set of hyperplanes in k-dimensional space
# Train svm model
library(e1071)
set.seed(1234)
fit.svm <- svm(output ~ ., data=train)
summary(fit.svm)
prediction <- predict(fit.svm, train)
table(train$output, prediction)

# Test the initial model
prediction <- predict(fit.svm, test)
table(test$output, prediction)
prop.table(table(prediction==test$output))

# Tuning specifications
Gamma <- 10^(-5:0)
Cost <- 10^(0:5)
tune <-  tune.svm(output ~ ., data=train,
                  gamma=Gamma, cost=Cost)
summary(tune)

# Create a tuned model
tuned.svm <- svm(output ~., data=train,
                 gamma=.01, cost=1)
prediction <- predict(tuned.svm, test)

# Evaluate new (tuned) model
library(caret)
confusionMatrix(prediction, test$output, positive="Present")
