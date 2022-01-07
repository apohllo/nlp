# Contextual question answering

The aim of this exercise is building a neural model able to contextually answer questions in the legal domain.

## Tasks

1. Get acquainted with the contents of the [Legal question answering dataset](lquad-1.0.tar.gz).
   The file format follows the SQuAD dataset.
2. Train a neural model able to answer legal questions. Use at least two models from [exercise 6](6-lm.md) as
   pre-trained models used as a base for fine-tuning. 
3. Report the obtained performance of the models (in the form of a table). The report should include *em* (exact match) and *F1* score.
   The development dataset should be used to pick up the best model (for
   each compared pre-trained model). The results should include performance on the development and the test datasets.
4. Generate and report the answers using the best model on questions you have prepared for the [exercise 9](9-neural.md). As a context
   take the regulation the questions were created for.
5. Answer the following questions:
   1. Which pre-trained model performs better on that task?
   2. Is the performance of the model compatible with the observations from exercise 6?
   3. What are the outcomes of the model on your own questions? Are they satisfying? If not, what might be the reason
      for that?

## Hints

