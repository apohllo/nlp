# Text classification

The task concentrates on content-based text classification.


## Tasks

1. Get acquainted with the data of the [Polish Cyberbullying detection dataset](https://huggingface.co/datasets/poleval2019_cyberbullying). 
   Pay special attention to the distribution of the positive and negative examples in the first task as well as
   distribution of the classes in the second task.
1. Train the following classifiers on the training sets (for the task 1 and the task 2):
   1. Bayesian classifier with TF * IDF weighting.
   1. Fasttext text classifier
   1. Transformer classifier (take into account that a number of experiments should be performed for this model).
1. Compare the results of classification on the test set. Select the appropriate measures (from accuracy, F1,
   macro/micro F1, MCC) to compare the results.
1. Select 1 TP, 1 TN, 1 FP and 1 FN from your predictions (for the best classifier) and compare the decisions of each
   classifier on these examples using [LIME](https://github.com/marcotcr/lime).
1. Answer the following questions:
   1. Which of the classifiers works the best for the task 1 and the task 2.
   1. Did you achieve results comparable with the results of [PolEval Task](http://2019.poleval.pl/index.php/results/)?
   1. Did you achieve results comparable with the [Klej leaderboard](https://klejbenchmark.com/leaderboard/)?
   1. Describe strengths and weaknesses of each of the compared algorithms.
   1. Do you think comparison of raw performance values on a single task is enough to assess the value of a given
      algorithm/model?
   1. Did LIME show that the models use valuable features/words when performing their decision?

## Hints

1. You can use [Google colab](https://colab.research.google.com/notebooks/intro.ipynb) to perform experiments which
   require access to GPU or TPU.
1. [Fasttext](https://fasttext.cc/docs/en/supervised-tutorial.html) is a popular baseline classifier. Don't report the Precision/Recall/F1 provided by
   Fasttext since they might be [wrong](https://github.com/facebookresearch/fastText/issues/261).
1. [Huggingface Transformers](https://github.com/huggingface/transformers) library is a popular library for performing NLP tasks base on the transformer
   architecture.
1. [Speech and Language Processing](https://web.stanford.edu/~jurafsky/slp3/) by Jurafsky and Martin 
   has a [chapter](https://web.stanford.edu/~jurafsky/slp3/4.pdf) devoted to the problem of classification.
1. [Huggingface course](https://huggingface.co/course/chapter1/1) is a great resource related to all necessary knowledge related to the most up-to-date NLP model training.
