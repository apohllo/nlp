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
1. Use [KRNNT](https://hub.docker.com/r/djstrong/krnnt2) or [Clarin-PL API](https://ws.clarin-pl.eu/tager.shtml) to tag and lemmatize the corpus. Note: Clarin allows to upload a ZIP file with the whole corpus and process it as one request.
1. Using the tagged corpus compute bigram statistic for the tokens containing:
   a. lemmatized, downcased word
   b. morphosyntactic category of the word (subst, fin, adj, etc.)
1. For example: "Ala ma kota.", which is tagged as:
   ```
   Ala	none
           Ala	subst:sg:nom:f	disamb
   ma	space
           mieć	fin:sg:ter:imperf	disamb
   kota	space
           kot	subst:sg:acc:m2	disamb
   .	none
           .	interp	disamb
   ```
   the algorithm should return the following bigrams: `ala:subst mieć:fin` and `mieć:fin kot:subst`.
1. Compute the same statistics as for the non-lemmatized words (i.e. PMI) and print top-10 entries with at least 5 occurrences.
1. Compute **trigram** counts for both corpora and perform the same filtering.
1. Use PMI (with 5 occurrence threshold) to compute top 10 results for the trigrams. Devise a method for computing the values, based on the
   results for bigrams.
1. Create a table comparing the results for copora without and with tagging and lemmatization (separate table for bigrams and trigrams).
1. Answer the following questions:
   1. Why do we have to filter the bigrams, rather than the token sequence?
   1. Which method works better for the bigrams and which for the trigrams?
   1. What types of expressions are discovered by the methods.
   1. Can you devise a different type of filtering that would yield better results?

## Hints

1. An n-gram is a sequence containing n tokens. A unigram is a sequence containing one token,
   a bigram is a sequence containing two consecutive tokens, etc.
1. *Pointwise mutual information* is used to identify correlated events. It's based on the assumption that the events
   follow normal distribution and that there is a minimal number of occurrences of the words. These assumptions hold
   only for a subset of words.
1. The methods presented in this exercise can be also used for the identification of words belonging to a given domain
   (e.g. law, biology, medicine).
1. [SRI LM](http://www.speech.sri.com/projects/srilm/) is useful for computing the counts of n-grams. 
   [Gensim](https://radimrehurek.com/gensim/models/phrases.html) also allows
   to compute these values.
1. ElasticSearch has a [shingle token filter](https://www.elastic.co/guide/en/elasticsearch/reference/current/analysis-shingle-tokenfilter.html) 
   which can be used to build the n-grams as well ("shingle" is not a typo, it's another name for n-gram).
1. BTW "multiword expression" is a multiword expression itself ;-)
1. A morphosyntactic analyzer provides the possible values of morphosyntactic tags for the words.
   E.g. for Polish "ma" word it can produce the following interpretations:
   ``` 
    ma	space
            mieć	fin:sg:ter:imperf
            mój  	adj:sg:nom:f:pos
            mój  	adj:sg:voc:f:pos
   ```
   1. The first interpretation shows that the word can be a verb in singular, in 3rd person.
   1. The second interpretation shows that the word can be an adjective in singular, in nominative, in feminine.
   1. The third interpretation shows that the word can be an adjective in singular, in vocative, in feminine.
1. The full list of tags is available at [NKJP](http://nkjp.pl/poliqarp/help/ense2.html).
1. A morphosyntactic tagger selects one of the interpretations of a word, taking into account its context.
   It can take the interpretation from a dictionary (like KRNNT), but it can also compute it dynamically (e.g. 
   [COMBO](https://github.com/360er0/COMBO) is a tagger that does not need a morphosyntactic analyzer).
1. The information provided by a tagger can be useful for many applications. You can select words from particular
   grammatical category or you can submit the data to a downstream task such as text classification.
1. More sophisticated algorithms for multiword expressions identification, such as 
   [AutoPhrase](https://github.com/shangjingbo1226/AutoPhrase) take into account more features, including:
   morphosyntactic tags, expression contexts, etc. and use data from e.g. Wikipedia, to automatically identify
   high-quality multiword expressions and use them to train MWE classifiers.

