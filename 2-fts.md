# Lemmatization and full text search (FTS)

The task is concentrated on using full text search engine (ElasticSearch) to perform basic search
operations in a text corpus.

## Tasks

Task objective (8 points):
1. Install ElasticSearch (ES).
2. Install an ES plugin for Polish https://github.com/allegro/elasticsearch-analysis-morfologik 
3. Define an ES analyzer for Polish texts containing:
   1. standard tokenizer
   2. synonym filter with alternative forms for months, e.g. `wrzesień`, `wrz`, `IX`.
   3. lowercase filter
   4. Morfologik-based lemmatizer
   5. lowercase filter (looks strange, but Morfologi produces capitalized base forms for proper names, so we have to lowercase them once more).
4. Define another analyzer for Polish, without the synonym filter.
5. Define an ES index for storing the contents of the corpus from lab 1 using both analyzers. Use different names for the fields analyzed with a different pipeline.
6. Load the data to the ES index.
7. Determine the number of documents containing the word `styczeń` (in any form) including and excluding the synonyms.
8. Download the QA pairs for the [FIQA dataset](https://huggingface.co/datasets/clarin-knext/fiqa-pl-qrels).
9. Compute NDCG@5 for the QA dataset (the test subset) for the following setusp:
   * synonyms enabled and disabled,
   * lemmatization in the query enabled and disabled.
10. (optional) Find three questions from the test subset with the following features:
   * the relevant document is returned by ES at position 1,
   * the relevant document is returned by ES  at position 4 or 5.
   * the relevant document is returned by ES  not found.
11. (optional) Analyze the possible reasons for these outcomes.


Answer the following questions (2 points):
1. What are the strengths and weaknesses of regular expressions versus full text search regarding processing of text?
2. Is full text search applicable to the question answering problem? Show at least 3 examples from the corpus to support your claim.


## Hints

1. Full text search engines were developed for storing and searching textual data.
1. The most popular FTSes are SOLR and ElasticSearch (ES).
1. Some relational databases support full text search, but usually it is limited and not easy to adapt.
1. Both for SOLR and ES there are plugins supporting Polish.
1. FTSes use *inverted-index* to store the data. At loading time the text is split by *tokenizer* into 
   *tokens* and individual tokens go through *filters*. The resulting tokens are placed as keys in a hash-like
   structure. The values are so called *posting lists*, containing pointers to the documents where the tokens come from.
1. The minimal FTS configuration requires two elements: a tokenizer and a set of filters (the set might be empty in the extreme
   case). **Changing the configuration of an index does not result in the new definitions being applied to the already
   stored documents.** In such cases the index has to be *rebuilt*, meaning that the documents have to be loaded once
   again.
1. FTSes contain a large number of tokenizers, e.g. they may know semantics of HTML documents and treat HTML tags as
   tokens. Some popular tokenizers include:
   1. *standard tokenizer* - based on the Unicode tokenization rules,
   1. *whitespace tokenizer* - which splits the tokens by white spaces,
   1. *url tokenizer* - which keeps the URLs as indivisible tokens.
1. Some tokens such as commas and full stops might be removed at the stage of filtering. Filtering of common tokens reduces the index size.
1. Some popular filters include:
   1. *lowercase filter* - which downcases the letters,
   1. *ASCII folding filter* - which removes Polish diacritics,
   1. *stop token filter* - which removes the specified tokens (described above),
   1. *lematizers* - which find the base form of a word,
   1. etc. (present implementation of ES has more than 50 filters)
1. **Lemmatization** is a process when the inflected form of a word is replaced with its base form, e.g
   the form *psu* is replaced with *pies*. You should notice that there are many ambiguous forms, e.g.
   *goli* can have the following base forms: *golić*, *gol* and *goły*. To overcome the ambiguity, FTSes 
   take very pragmatic approach - for a given inflected form all possible base forms are put in the index.
   Even though it's not valid from the linguistics' point of view, it works well in practice.
1. [Term vector API](https://www.elastic.co/guide/en/elasticsearch/reference/current/docs-termvectors.html) allows to retrieve useful 
   statistics of a given term in a particular document or in the whole document collection.
1. Polish retrieval models comparison is available at :https://huggingface.co/spaces/sdadas/pirb
2. You can try to use the following Dockerfile for ElasticSearch with installed Morfologik plugin:
   ```
   ARG es_version
   FROM docker.elastic.co/elasticsearch/elasticsearch:$es_version
   # the ARG has to be doubled,
   # cf. https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
   ARG es_version
   RUN /usr/share/elasticsearch/bin/elasticsearch-plugin install pl.allegro.tech.elasticsearch.plugin:elasticsearch-analysis-morfologik:$es_version
   ```
3. To build the docker run e.g. `docker build . --build-arg es_version=8.8.2` in the directory containing the Dockerfile.
