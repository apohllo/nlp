# Neural search for question answering

The exercise introduces the problem of passage retrieval, an important step in factual question answering. 
This part concentrates on the methods for retrieving
the content of documents that might be useful for answering the question. We compare lexical text
representations (e.g. ElasticSearch default behaviour), with dense text representations (e.g. [multilingual E5](https://huggingface.co/intfloat/multilingual-e5-base) neural model).

## Tasks

Objectives (8 points)

1. Read the documentation of the [document store](https://docs.haystack.deepset.ai/docs/document_store) and
   the [retriever](https://docs.haystack.deepset.ai/docs/retriever) in the 
   [Haystack framework](https://haystack.deepset.ai/).
2. Install Haystack framework (e.g. with `pip install 'farm-haystack[all]'`).
3. Configure a document store based on Faiss supported by multilingual E5 model:
   1. For Faiss use [multilingual E5](https://huggingface.co/intfloat/multilingual-e5-base) or [silver retriever base](https://huggingface.co/ipipan/silver-retriever-base-v1) encoder.
   3. **Warning:** If you use E5, make sure to [properly configure](https://github.com/deepset-ai/haystack/issues/5242) the store.
   4. In the case you have problems using Faiss, you can use `InMemoryDocumentStore`, but this will require to re-index
      all documents each time the script is run, which is time consuming.
4. Load the documents (passages) from the FiQA corpus.
5. Use the set of questions and the scorings defined in this corpus, to compute NDCG@5 for the dense retriever.
6. Compare the NDCG score from this exercise with the score from [lab 2](2-fts.md) and from [lab 6](6-classification.md).
7. **Bonus** (+2p) Combine dense retrieval with classification model from [lab 6](6-classification.md) to implement a two-step
   retrieval. Compute NDCG@5 for this combined model.
8. **Bonus** (+2p) Use a different dense encoder, e.g. [E5 large](https://huggingface.co/intfloat/multilingual-e5-large) or [Polish Roberta Base](https://huggingface.co/sdadas/mmlw-retrieval-roberta-base) and compute NDCG@5.

Questions (2 points)

1. Which of the methods: lexical match (e.g. ElasticSearch) or dense representation works better? 
2. Which of the methods is faster?
3. Try to determine the other pros and cons of using lexical search and dense document retrieval models.
   

## Hints

1. Haystack is a framework for buliding question answering applications.
2. Lexical document retrieval is based on traditional NLP pipelines (e.g. lemmatization),
   i.e. models based on bag of words. ElasticSearch typical usage is based on lexical search model.
3. Dense document retrieval is based on dense vector models provided by neural networks. These dense vectors might be 
   generated directly, by e.g. avaraging the vectors of word embeddings belonging to a given text fragment. Yet such
   models performance is inferior to sparse models.
4. More sophisticated models are trained directly on the document retrieval task. E.g. [DPR](https://arxiv.org/abs/2004.04906)
   uses a bi-encoder architecture that has a separate neural network for encoding the question and for encoding the passage.
   [E5](https://arxiv.org/abs/2212.03533) model has a shared encoder architecture.
   These netowrks are trained to maximise the dot-product of the vectors produced by each of the networks.
5. Using dense vector representation requires computing the dense vectors for all passages in the dataset. 
   These vectors might be stored in document stores such as [FAISS](https://github.com/facebookresearch/faiss) for faster retrieval, 
   especially when the dataset is very large (does not fit into memory).
6. [Polish retrieval benchmark](https://huggingface.co/spaces/sdadas/pirb) lists and compares the models that implement dense retrieval for Polish.
