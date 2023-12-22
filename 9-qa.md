# Contextual question answering

The aim of this exercise is building a neural model able to answer contextual questions in the legal domain.

## Tasks

## Objectives (8 points)

1. Get acquainted with the [Simple legal questions dataset](https://github.com/apohllo/simple-legal-questions-pl) (you need to send your github login to gain access to the dataset).
2. **Bonus +5 points** Select one of the open issues in the dataset, provide the answers for the questions in the
   package and open a pull request with the answers.
3. The legal questions dataset is your **test dataset**.
4. [PoQuAD](https://huggingface.co/datasets/clarin-pl/poquad) is your **train and validation dataset** (use the splits from the repo).
5. **Warning** PoQuAD has a python API compatible with the `datasets` library, but it only provides the **extractive answers**, even
   though the abstractive answers are available in the JSON files. So you have to read the JSON files directly.
6. **Bonus +5 points** If you write a pull request with the changes to the API of the dataset that will expose the abstractive answers
   and the impossible questions, and the PR will be accepted, you will gain additionl 5 points.
7. Train a neural model able to answer the legal questions. Make sure you are using a machine
   with a GPU, since training the model on CPU will be very long. 
   The training should include at least 3 epochs (depending on the size of the training set you are using). 
   As the pre-trained models you can use (or any other model that is able to perform abstractive Question Answering):
   * [plT5-base](https://huggingface.co/allegro/plt5-base)
   * [plT5-large](https://huggingface.co/allegro/plt5-large)
8. If you have problems training the model, you can use [apohllo/plt5-base-poquad](https://huggingface.co/apohllo/plt5-base-poquad) which was trained on PoQuAD. **This will result in  subtraction of 2 points**. 
9. Report the obtained performance of the model (in the form of a table). The report should include *exact match* and *F1 score* 
   for the tokens appearing both in the reference and the predicted answer.
10. Report the best results obtained on the validation dataset and the corresponding results on your test dataset. The results on the 
   test set have to be obtained for the model that yield the best result on the validation dataset.
11. Generate, report and analyze the answers for at least 10 questions provided by the best model on you test dataset.
   
## Questions (2 points)

1. Does the performance on the validation dataset reflects the performance on your test set?
2. What are the outcomes of the model on your test questions? Are they satisfying? If not, what might be the reason
   for that?
3. Why extractive question answering is not well suited for inflectional languages?

## Hints
1. Contextual question answering can be resolved by at lest two approaches:
   * extractive QA (EQA) - the model has to select a consecutive sequence of tokens from the context which form the question.
   * abstractive QA (AQA) - the model has to generate a sequence of tokens, based on the question and the provided context.
2. Decoder-only models, like BERT, are not able to answer questions in the AQA paradigm, however they are very well suited for EQA.
3. To resolve AQA you need a generative model, such as (m)T%, BART or GPT. These model (generally) are called sequence-to-sequence
   or text-to-text models, since they take text as the input and produce text as the output.
4. Text-to-text model generate the text autoregresively, i.e. they produce one token at a given step and then feed the generated token 
   (and all tokens generated so far) as the input to the model when generating the next token.
   As a result the generation process is pretty slow.
6. Many NLP tasks base on the neural networks can be solved with
   [ready-made scripts](https://github.com/huggingface/transformers/tree/main/examples/pytorch) available in the Transformers library.
8. A model able to answer questions in the AQA paradigm may be trained with the
   [run_seq2seq_qa.py](https://github.com/huggingface/transformers/tree/main/examples/pytorch/question-answering)
   script available in Transfomers.
   If using such a script make sure you are acquianted with the available training options - some of the are defined in the
   [script itself](https://github.com/huggingface/transformers/blob/main/examples/pytorch/question-answering/run_seq2seq_qa.py#L56), 
   but most of them are inherited from the general [trainer](https://huggingface.co/docs/transformers/main_classes/trainer#transformers.TrainingArguments)
   or [seq2seq trainer](https://huggingface.co/docs/transformers/main_classes/trainer#transformers.Seq2SeqTrainingArguments).

