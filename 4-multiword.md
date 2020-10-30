# Multiword expressions identification and extraction

The task shows two simple methods useful for identifying multiword expressions (MWE) in corpora.

## Tasks

1. Use SpaCy [tokenizer API](https://spacy.io/api/tokenizer) to tokenize the text from the law corpus.
1. Compute **bigram** counts of downcased tokens.  Given the sentence: "The quick brown fox jumps over the
   lazy dog.", the bigram counts are as follows:
   1. "the quick": 1
   1. "quick brown": 1
   1. "brown fox": 1
   1. ...
   1. "dog .": 1
1. Discard bigrams containing characters other than letters. Make sure that you discard the invalid entries **after**
   computing the bigram counts.
1. Use [pointwise mutual information](https://en.wikipedia.org/wiki/Pointwise_mutual_information) to compute the measure 
   for all pairs of words. 
1. Sort the word pairs according to that measure in the descending order and determine top 10 entries.
1. Filter bigrams with number of occurrences lower than 5. Determine top 10 entries for the remaining dataset (>=5
   occurrences).
1. Use [log likelihood ratio](http://tdunning.blogspot.com/2008/03/surprise-and-coincidence.html) (LLR) to compute the measure
   for all pairs of words.
1. Sort the word pairs according to that measure in the descending order and display top 10 entries.
1. Compute **trigram** counts for the whole corpus and perform the same filtering.
1. Use PMI (with 5 occurrence threshold) and LLR to compute top 10 results for the trigrams. Devise a method for computing the values, based on the
   results for bigrams.
1. Create a table comparing the methods (separate table for bigrams and trigrams).
1. Answer the following questions:
   1. Why do we have to filter the bigrams, rather than the token sequence?
   1. Which measure (PMI, PMI with filtering, LLR) works better for the bigrams and which for the trigrams?
   1. What types of expressions are discovered by the methods.
   1. Can you devise a different type of filtering that would yield better results?

## Hints

1. An n-gram is a sequence containing n words. A unigram is a sequence containing one word,
   a bigram is a sequence containing two consecutive words, etc.
1. *Pointwise mutual information* is used to identify correlated events. It's based on the assumption that the events
   follow normal distribution and that there is a minimal number of occurrences of the words. These assumptions hold
   only for a subset of words.
1. Log likelihood ratio test doesn't have these assumption. This makes it better suited for the task.
1. There is [LLR implementation](https://github.com/tdunning/python-llr) in Python, implemented by Ted Dunning - the
   author of the important work [Accurate Methods for the Statistics of Surprise and
   Coincidence](https://aclweb.org/anthology/J93-1003) which introduces LLR to NLP.
1. The methods presented in this exercise can be also used for the identification of words belonging to a given domain
   (e.g. law, biology, medicine).
1. [SRI LM](http://www.speech.sri.com/projects/srilm/) is useful for computing the counts of n-grams. 
   [Gensim](https://radimrehurek.com/gensim/models/phrases.html) also allows
   to compute these values.
1. ElasticSearch has a [shingle token filter](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-shingle-tokenfilter.html) 
   which can be used to build the n-grams as well.
1. BTW "multiword expressions" is a mutliword expression itself ;-)
