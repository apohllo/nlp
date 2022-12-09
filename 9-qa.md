# Contextual question answering

The aim of this exercise is building a neural model able to answer contextual questions in the legal domain.

## Tasks

1. Get acquainted with the [Simple legal questions dataset](https://github.com/apohllo/simple-legal-questions-pl).
2. Select one open issue in the dataset, provide the answers for the questions in the package and open a pull request with the answers.
3. The subset of the answers that you have provided in point 2 is your *test dataset*. If in the dataset there are questions that are 
   the same as the questions in your test set, make the questions and the answers part of your test dataset (i.e. remove them from the training set).
4. The remaing questions and answers are your *training set*. Divide that set into *training* and *validation* subsets. The validation part should 
   be selected as 20% of the original training set. Make sure that there are no questions in the validation set that are present in the training 
   subset. If there are such questions, make them part of the validation set.
5. If the training set is small (less than 1 thousand question+answer pairs) use one of the available QA dataset, 
   e.g. [PoQUAD](https://github.com/ipipan/poquad) or [SQUAD](https://huggingface.co/datasets/squad). Using the second dataset is sensible, if you
   are training a multilingual model, like mT5.
7. Train a neural model able to answer the legal questions. Fine-tune at least two pre-trained models. Make sure you are using a machine
   with a GPU, since training the model on CPU will be very long. 
   The training should include at least 10 epochs (depending on the size of the training set you are using). 
   The pre-trained models you can use include:
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
   4. Why extractive question answering is not well suited for inflectional languages?
   5. Why you have to remove the duplicated questions from the training and the validation subsets?

## Hints
1. Contextual question answering can be resolved by at lest two approaches:
   * extractive QA (EQA) - the model has to select a consecutive sequence of tokens from the context which form the question.
   * abstractive QA (AQA) - the model has to generate a sequence of tokens, based on the question and the provided context.
2. Decoder only models, like BERT, are not able to answer questions in the AQA paradigm, however they are very well suited for EQA.
3. To resolve AQA you need a generative model, such as (m)T%, BART or GPT. These model (generally) are called sequence-to-sequence
   or text-to-text models, since they take text as the input and produce text as the output.
4. Text-to-text model generate the text autoregresively, i.e. they produce one token at a given step and then feed the generated token 
   (and all tokens generated so far) as the input to the model when generating the next token. As a result the generation process is pretty slow.
5. Many NLP tasks base on the neural networks can be solved with [ready-made scripts](https://github.com/huggingface/transformers/tree/main/examples/pytorch) available in the Transformers library.
6. A model able to answer questions in the AQA paradigm may be trained with the [run_seq2seq_qa.py](https://github.com/huggingface/transformers/tree/main/examples/pytorch/question-answering) script available in Transfomers.
   If using such a script make sure you are acquianted with the available training options - some of the are defined in the
   [script itself](https://github.com/huggingface/transformers/blob/main/examples/pytorch/question-answering/run_seq2seq_qa.py#L56), 
   but most of them are inherited from the general [trainer](https://huggingface.co/docs/transformers/main_classes/trainer#transformers.TrainingArguments)
   or [seq2seq trainer](https://huggingface.co/docs/transformers/main_classes/trainer#transformers.Seq2SeqTrainingArguments).

