# Contextual question answering

The aim of this exercise is building a neural model able to answer contextual questions in the legal domain.

## Tasks

1. Get acquainted with the [Simple legal questions dataset](https://github.com/apohllo/simple-legal-questions-pl).
2. Select one open issue in the dataset, provide the answers for the questions in the package and open a pull request with the answers.
3. The subset of the answers that you have provided in point 2 is your *test dataset*. If in the dataset there are questions that are 
   the same as the questions in your test set, make the questions and the answers part of your test dataset (i.e. remove them from the training set).
4. The remaing questions and answers are your *training set*. Divide that set into *training* and *validation* subsets. The validation part should 
   be selected 20% of the original training set. Make sure that there are no questions in the validation set that are present in the created training 
   set. If there are such questions, make them part of the validation set.
5. If the training set is small (less than 1 thousand question+answer pairs) use one of the available QA dataset for Polish, 
   e.g. [PoQUAD](https://github.com/ipipan/poquad) or [SQUAD](https://huggingface.co/datasets/squad). Using the second dataset is sensible, if you
   are training a multilingual model, like mT5.
7. Train a neural model able to answer the legal questions. Fine-tune at least two pre-trained models. The meaningful models include:
   * [plT5-base](https://huggingface.co/allegro/plt5-base)
   * [plT5-large](https://huggingface.co/allegro/plt5-large)
   * [mT5-base](https://huggingface.co/google/mt5-base)
   * [mT5-large](https://huggingface.co/google/mt5-large)
8. Report the obtained performance of the models (in the form of a table). The report should include *exact match* and *F1 score* 
   for the tokens appearing both in the reference and the predicted answer.
9. Report the best results obtained on the validation dataset and the corresponding results on your test dataset. The results on the 
   test set have to be obtained for the model that yield the best result on the validation dataset.
10. Generate, report and analyze the answers provided by the best model on you test dataset.
11. * optional: perform hyperparameter tuning for the models to obtain better results. Take into account some of the following parameters:
    * learning rate
    * gradient accumulation steps
    * batch size
    * gradient clipping
    * learning rate schedule 
13. Answer the following questions:
   1. Which pre-trained model performs better on that task?
   2. Does the performance on the validation dataset reflects the performance on your test set?
   3. What are the outcomes of the model on your own questions? Are they satisfying? If not, what might be the reason
      for that?

## Hints

* TODO

