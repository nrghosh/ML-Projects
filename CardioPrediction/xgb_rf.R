# Part 1: Data Prep 
load("/Users/nikhilghosh/Desktop/DM:ML/asgn4/heart.rdata")
set.seed(1234)
index <- sample(nrow(heart), 0.75*nrow(heart))
train <- heart[index,]
test <- heart[-index,]

# Part 2: Random Forest Model
# Ensemble learning method for classification, training many decision trees and outputting the mode
library(randomForest)
library(caret)
set.seed(1234)
fit.forest <- randomForest(output ~ ., 
                           data=train, 
                           na.action=na.roughfix,
                           ntree=1000,
                           importance=TRUE)
pred <- predict(fit.forest, test)
confusionMatrix(pred, test$output, positive="Present")

# The accuracy of this model is 0.79, the sensitivity is 0.79, and specificity is rounded to 0.795. 


# Part 3: XGB Boosting
# 'Extreme Gradient Boosting' uses an ensemble of weak decision models for classification problems
# Aggregate many 'weak learns' (guesses that are slightly above average/random chance) into strong
# prediction probability.
library(caret)
set.seed(1234)
tc <- trainControl(method = "cv",
                   number = 5)
xgbmodel <- train(output ~ . , 
                data = train,
                method = "xgbTree",
                trControl = tc,
                tuneLength = 5)
predict <- predict(xgbmodel, newdata=test)
confusionMatrix(predict, test$output, positive="Present")

# The accuracy of this model is 0.71, the sensitivity is 0.79, and specificity is 0.64. 
