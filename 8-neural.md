# Neural search for question answering

The exercise introduces the problem of factual question answering. This part concentrates on the methods for retrieving
the content of documents that potentialy might be useful for answering the question. We compare sparse text
representations (e.g. ElasticSearch default behaviour), with dense text representations (e.g. Dense Passage Retriever
bi-encoder neural model).

## Tasks

1. Read the documentation of the [document store](https://haystack.deepset.ai/reference/document-store) and
   the [document retriever](https://haystack.deepset.ai/reference/retriever) in the 
   [Haystack framework](https://haystack.deepset.ai/overview/intro).
1. Install Haystack framework. You may need to used [this fork](https://github.com/apohllo/haystack/tree/use-auto-tokenizer-by-default) 
   to get support for Polish QA models.
3. Configure one document store based on ElasticSearch and another document store based on Faiss supported by DPR:
   1. The ES store should properly process Polish documents.
   2. For DPR you should use [enelpol/czywiesz-question](https://huggingface.co/enelpol/czywiesz-question) and 
      [enelpol/czywiesz-context](https://huggingface.co/enelpol/czywiesz-context) encoders.
   3. **Warning:** Make sure to used models uploaded past 21st of December 2021, since the first model version included a bug.
4. Pre-process all documents from the set of Polish bills (used in the previous exercises), but splitting them into
   individual articles: 
   1. You can apply a simple heuristic that searches for `Art.` at the beginnign of the processed line, to identify the passages. 
   2. Assing identifiers to the passages by combining the file name with the article id.
   3. There might be repeated identifiers, since we use a heuristic. You should ignore that problem - just make sure
      that you load only one passage with a specific id.
3. Load the passages from previous point to the document stores described in point 2.
8. Use the set of questions defined in [this dataset](https://github.com/apohllo/simple-legal-questions-pl) to assess the performance of the document stores.
9. Compare the performance of the data stores using the following metrics: Pr@1, Rc@1, Pr@3, Rc@3.
10. Answer the following questions:
    1. Which of the document stores performs better? Take into account the different metrics enumerated in the previous
       point.
    2. Which of the document stores is faster?
    3. Try to determine the other pros and cons of using sparse and dense document retrieval models.
   

## Hints

1. Haystack is a framework for buliding question answering applications.
2. Sparse document retrieval is based on sparse vector models, i.e. models based on bag of words. ElasticSearch typical
   usage is based on sparse document model.
3. Dense document retrieval is based on dense vector models provided by neural networks. These dense vectors might be 
   generated directly, by e.g. avaraging the vectors of word embeddings belonging to a given text fragment. Yet such
   models performance is inferior to sparse models.
4. More sophisticated models are trained directly on the document retrieval task. E.g. [DPR](https://arxiv.org/abs/2004.04906)
   uses a bi-encoder architecture that has a separate neural network for encoding the question and for encoding the passage.
   These netowrks are trained to maximise the dot-product of the vectors produced by each of the networks.
5. Using dense vector representation requires computing the dense vectors for all passages in the dataset. 
   These vectors might be stored in document stores such as [FAISS](https://github.com/facebookresearch/faiss) for faster retrieval, 
   especially when the dataset is very large (does not fit into memory).
6. Pr@n and Rc@n meen *precision at n* and *recall at n*. They are computed by retrieving `n` top documents and
   computing the metrics in a regular way. E.g. if among 3 retrieved documents there are 2 valid documents out of 5, 
   Pr@3 is 2/3 = 66% and Rc@3 is 2/5 = 40%.
