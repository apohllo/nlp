# Multiword expressions identification and extraction

The task shows two simple methods useful for identifying multiword expressions (MWE) in corpora.

## Tasks

1. Compute **bigram** counts in the corpora, ignoring bigrams which contain at least one token that is not a word
   (it contains characters other than letters). The text has to be properly normalized before the counts are computed:
   it should be downcased and all punctuation should be removed. Given the sentence: "The quick brown fox jumps over the
   lazy dog", the bigram counts are as follows:
   1. "the quick": 1
   1. "quick brown": 1
   1. "brown fox": 1
   1. etc.
1. Use [pointwise mutual information](https://en.wikipedia.org/wiki/Pointwise_mutual_information) to compute the measure 
   for all pairs of words. 
1. Sort the word pairs according to that measure in the descending order and display 30 top results.
1. Use [log likelihood ratio](http://tdunning.blogspot.com/2008/03/surprise-and-coincidence.html) (LLR) to compute the measure
   for all pairs of words.
1. Sort the word pairs according to that measure in the descending order and display 30 top results.
1. Answer the following questions:
   1. Which measure works better for the problem?
   1. What would be needed, besides good measure, to build a dictionary of multiword expressions?
   1. Can you identify a certain threshold which clearly divides the *good* expressions from the *bad*?

## Hints

1. An n-gram is a sequence containing n words. A unigram is a sequence containing one word,
   a bigram is a sequence containing two words, etc.
1. Pointwise mutual information is used to identify correlated events. It's based on the assumption that the events
   follow normal distribution and that there is a minimal number of occurrences of the words. These assumptions hold
   only for a subset of words.
1. Log likelihood ratio test doesn't have these assumption. This makes it better suited for the task.
1. There is [LLR implementation](https://github.com/tdunning/python-llr) in Python, implemented by Ted Dunning - the
   author of the important work [Accurate Methods for the Statistics of Surprise and
   Coincidence](https://aclweb.org/anthology/J93-1003) which introduces LLR to NLP.
1. The methods presented in this exercise can be also used for the identification of words belonging to a given domain
   (e.g. law, biology, medicine).
1. [SRI LM](http://www.speech.sri.com/projects/srilm/) is useful for computing the counts of n-grams.
1. ElasticSearch has a [shingle token filter](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-shingle-tokenfilter.html) 
   which can be used to build the n-grams as well.
1. More sophisticated algorithms for multiword expressions identification, such as 
   [AutoPhrase](https://github.com/shangjingbo1226/AutoPhrase) take into account more features including:
   morphosyntactic tags, expression contexts, etc. and use data from e.g. Wikipedia, to automatically identify
   high-quality multiword expressions and use them to train MWE classifiers.
1. BTW "multiword expressions" is a mutliword expression itself ;-)
