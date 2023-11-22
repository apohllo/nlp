# Text classification

The task concentrates on classification classification of sentence pairs.

This type of classification is useful for problmes such as determining the similarity of sentences or
checking if a text passage contains an answer to a question.


## Tasks

Objectives (8 points):

1. Use the FIQA-PL dataset that was used in lab 1 **and** lab lab 2 (so we need the passages, the questions and their
   relations).
1. Create a dataset of positive and negative sentence pairs. In each pair the first element is a question and the
   second element is a passage. Use the relations to mark the positive pairs (i.e. pairs where the question is answered
   by the passage). Use your own strategy to mark negative pairs (i.e. you can draw the negative examples, but there are
   better strategies to define the negative examples). The number of negative examples should be much larger than the
   number of positive examples.
1. The dataset from point 2 should be split into training, evaluation and testing subsets.
1. Report the results you have obtained for the model. Use appropriate measuers, since the dataset is not balanced.
1. Train a text classifier using on the Transformers library that distinguishes between the positive and the negative
   pairs. To make the process managable use models of size `base` and a runtime providing GPU/TPU acceleration.
1. Use the classifier as a re-ranker for finding the the answers to the questions. Since the re-ranker is slow, you
   have to limit the subset of possible passages to top-n (10, 50 or 100 - depending on your GPU) texts returned by much faster model, e.g. FTS.
1. Compute how much the result of searching the passages improved over the results from lab 2.

Quesitons (2 points):

TBA

## Hints

1. You can use [this notebook](https://github.com/apohllo/sztuczna-inteligencja-rozwiazania/blob/master/lab5/lab_5.ipynb) as a skeleton for the training procedure.
1. You can use [Google colab](https://colab.research.google.com/notebooks/intro.ipynb) to perform experiments which
   require access to GPU or TPU.
1. [Huggingface Transformers](https://github.com/huggingface/transformers) library is a popular library for performing NLP tasks base on the transformer
   architecture.
1. [Speech and Language Processing](https://web.stanford.edu/~jurafsky/slp3/) by Jurafsky and Martin 
   has a [chapter](https://web.stanford.edu/~jurafsky/slp3/4.pdf) devoted to the problem of classification.
1. [Huggingface course](https://huggingface.co/course/chapter1/1) is a great resource related to all necessary knowledge related to the most up-to-date NLP model training.
