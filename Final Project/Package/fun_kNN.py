import pandas as pd
import random
from sklearn.neighbors import KNeighborsClassifier
from sklearn.model_selection import GridSearchCV
from sklearn import metrics
import matplotlib.pyplot as plt
import seaborn as sns

def knn_func(df_pca):
    from sklearn.model_selection import train_test_split

    x = df_pca.drop('Class', axis=1).values
    y = df_pca['Class'].values

    # Generate a random value for random_state
    random_state = random.randint(0, 999)
    # Split training set and test set
    x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.3, random_state=random_state, stratify=y)

    # Set up the parameter grid for grid search
    param_grid = {'n_neighbors': [3, 5, 7, 9, 11]}

    # Create a k-nearest neighbors (KNN) model
    knnModel = KNeighborsClassifier()

    # Perform grid search with cross-validation
    grid_search = GridSearchCV(knnModel, param_grid, cv=5)
    grid_search.fit(x_train, y_train)

    # Get the best model and its hyperparameters
    hyper_model = grid_search.best_estimator_
    hyper_params = grid_search.best_params_

    print("Best Hyperparameters:", hyper_params)

    # Predict on the training data
    y_train_predicted = hyper_model.predict(x_train)
    train_accuracy = metrics.accuracy_score(y_train, y_train_predicted)
    print("Training Accuracy:", train_accuracy)

    # Predict on the test data
    y_test_predicted = hyper_model.predict(x_test)
    test_accuracy = metrics.accuracy_score(y_test, y_test_predicted)
    print('Testing Accuracy: ', test_accuracy)

    # Build the DataFrame of the training set
    df_train = pd.DataFrame(x_train, columns=['PC1', 'PC2', 'PC3'])
    df_train['Class'] = y_train
    df_train['Predict'] = y_train_predicted

    # Build the DataFrame of the test set
    df_test = pd.DataFrame(x_test, columns=['PC1', 'PC2', 'PC3'])
    df_test['Class'] = y_test
    df_test['Predict'] = y_test_predicted

    # # Plot classification results using scatter matrix
    # plt.scatter(df_test['PC1'], df_test['PC2'], c=df_test['Predict'], marker='o', s=50, label='Predicted')
    # plt.scatter(df_test['PC1'], df_test['PC2'], c=df_test['Class'], marker='x', s=25, label='Actual')
    # plt.xlabel('PC1')
    # plt.ylabel('PC2')
    # plt.legend()

    # # Plot matrix of KNN predictions using heatmap
    # confusion_matrix = metrics.confusion_matrix(y_test, y_test_predicted)

    # sns.heatmap(confusion_matrix, annot=True, cmap='Blues', fmt='d')
    # plt.xlabel('Predicted')
    # plt.ylabel('Actual')
    # plt.show()

    return df_train, df_test