rm(list = ls())

library(dplyr)
library(keras) 
library(tensorflow) #

library(mlbench)


# Data ----

data(BostonHousing)
dim(BostonHousing)
head(BostonHousing)
str(BostonHousing)

# Separate into training (70%) and testing (30%)
index <- sample(nrow(BostonHousing), nrow(BostonHousing) * 0.7, replace = FALSE)
Dtrain <- BostonHousing[index,]
Dtest <- BostonHousing[-index,]

X_train <- Dtrain %>%
    select(-chas) %>%
    select(-medv) %>%
    scale()
# Effect of scaling
# apply(Dtrain %>%
#           select(-chas) %>%
#           select(-medv), 2, mean)
# apply(X_train, 2, mean)
# apply(X_train, 2, sd)

y_train <- Dtrain %>%
    select(medv) %>%
    scale()

X_test <- Dtest %>%
    select(-chas) %>%
    select(-medv) %>%
    scale()

y_test <- Dtest %>%
    select(medv) %>%
    scale()

# NN from scratch ----
model <- keras_model_sequential()
model %>%
    layer_dense(units = 30, activation = "relu") %>%
    layer_dropout(rate = 0.25) %>%
    layer_dense(units = 30, activation = "relu") %>%
    layer_dense(units = 1, activation = "linear")

model %>% compile(
    loss = "mean_squared_error", # https://keras.io/api/losses/
    # optimizer = "adam"
    optimizer = optimizer_adam(learning_rate = 0.01, decay = 0)
)

history = model %>%
    fit(x = X_train, y = y_train,
        # validation_split = 0.1,
        epochs = 50, batch_size = 30)

pred <- predict(model, X_test)
e <- y_test - pred
# RMSE
sqrt(mean(e^2))
# MAE
mean(abs(e))

# RF ----
library(ranger)
mrf <- ranger(y = y_train, x = X_train)
pred <- predict(mrf, X_test)$predictions # predict.ranger
e <- y_test - pred
# RMSE
sqrt(mean(e^2))
# MAE
mean(abs(e))

# NN transfer learning ----

# https://keras.io/guides/transfer_learning/
# https://towardsdatascience.com/understanding-and-coding-a-resnet-in-keras-446d7ff84d33

# the code below doesn't work for our data because of the
# input dimensions that must be at least 32x32 with 3 channels
# we have 1 x 30
base_model <- application_resnet50(
    include_top = FALSE,
    weights = "imagenet",
    input_tensor = NULL,
    input_shape = dim(train_x)[-1], #input dimensions that must be at least 32x32
    pooling = "avg",
    classes = 2
)

#freeze the added layers
for (layer in base_model$layers)
    layer$trainable <- FALSE
# summary(base_model)

model_output <-
    # layer_resizing(height = 300, width = 300, interpolation = "bilinear") %>%
    base_model$output %>%
    layer_flatten(trainable = TRUE) %>%
    layer_dense(units = 512, activation = "relu", trainable = TRUE) %>%
    # layer_batch_normalization(trainable = TRUE) %>%
    layer_dropout(rate = 0.5, trainable = TRUE) %>%
    layer_dense(units = 1, trainable = TRUE, activation = "sigmoid")

model <- keras_model(inputs = base_model$input, outputs = model_output)


