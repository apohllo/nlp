# Text classification

The task concentrates on classification of sentence pairs.

This type of classification is useful for problems such as determining the similarity of sentences or
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
1. Train a text classifier using the Transformers library that distinguishes between the positive and the negative
   pairs. To make the process manageable use models of size `base` and a runtime providing GPU/TPU acceleration.
   Consult the discussions related to fine-tuning Transformer models to select sensible set of parameters.
   You can also run several trainings with different hyper-parameters, if you have access to large computing resources.
1. Report the results you have obtained for the model. Use appropriate measures, since the dataset is not balanced.
1. Use the classifier as a re-ranker for finding the answers to the questions. Since the re-ranker is slow, you
   have to limit the subset of possible passages to top-n (10, 50 or 100 - depending on your GPU) texts returned by much faster model, e.g. FTS.
1. The scheme for re-ranking is as follows:
   1. Find passage candidates using FTS, where the query is the question.
   1. Take top-n results returned by FTS.
   1. Use the model to classify all pairs, where the first sentence is the question (query) and the second sentence is
      the passage returned by the FTS.
   1. Use the score returned by the model (i.e. the probability of the **positive** outcome) to re-rank the passages.
1. Compute how much the result of searching the passages improved over the results from lab 2. Use NDCG to compare the
   results.

Questions (2 points):

1. Do you think simpler methods, like Bayesian bag-of-words model, would work for sentence-pair classification? Justify
   your answer.
1. What hyper-parameters you have selected for the training? What resources (papers, tutorial) you have consulted to 
   select these hyper-parameters?
1. Think about pros and cons of the neural-network models with respect to natural language processing. Provide at least
   2 pros and 2 cons.

## Hints

1. You can use [this notebook](https://github.com/apohllo/sztuczna-inteligencja/tree/master/lab5) as a skeleton for the training procedure.
   The relevant code starts in the "Klasyfikacja tekstu" section.
1. You can use [Google colab](https://colab.research.google.com/notebooks/intro.ipynb) to perform experiments which
   require access to GPU or TPU.
1. [Huggingface Transformers](https://github.com/huggingface/transformers) library is a popular library for performing NLP tasks base on the transformer
   architecture.
1. [Speech and Language Processing](https://web.stanford.edu/~jurafsky/slp3/) by Jurafsky and Martin 
   has a [chapter](https://web.stanford.edu/~jurafsky/slp3/4.pdf) devoted to the problem of classification.
1. [Huggingface course](https://huggingface.co/course/chapter1/1) is a great resource related to all necessary knowledge related to the most up-to-date NLP model training.
