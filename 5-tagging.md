# Morphosyntactic tagging

Morphosyntactic tagging is one of the core algorithms in NLP. It assigns morphological
and (in some languages) syntactic tags to the words in a text. E.g. this allows to distinguish
between the major grammatical categories, such as nouns and verbs.


## Tasks

1. Download [docker image](https://hub.docker.com/r/djstrong/krnnt2) of KRNNT2. It includes the following tools:
   1. Morfeusz2 - morphological dictionary
   1. Corpus2 - corpus access library
   1. Toki - tokenizer for Polish
   1. Maca - morphosyntactic analyzer
   1. KRNNT - Polish tagger
1. Use the tool to tag and lemmatize the law corpus.
1. Using the tagged corpus compute bigram statistic for the tokens containing:
   1. lemmatized, downcased word
   1. morphosyntactic **category** of the word (`subst`, `fin`, `adj`, etc.)
1. Discard bigrams containing characters other than letters. Make sure that you discard the invalid entries after computing the bigram counts.
1. For example: "Ala ma kota", which is tagged as:
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
1. Compute LLR statistic for this dataset.
1. Partition the entries based on the syntactic categories of the words, i.e. all bigrams having the form of 
   `w1:adj` `w2:subst` should be placed in one partition (the order of the words may not be changed).
1. Select the 10 largest partitions (partitions with the larges number of entries).
1. Use the computed LLR measure to select 5 bigrams for each of the largest categories.
1. Using the results from the previous step answer the following questions:
   1. What types of bigrams have been found?
   1. Which of the category-pairs indicate valuable multiword expressions? Do they have anything in common?
   1. Which signal: LLR score or syntactic category is more useful for determining genuine multiword expressions?
   1. Can you describe a different use-case where the morphosyntactic category is useful for resolving a real-world
      problem?

## Hints

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
1. A morphosyntactic tagger selects one of the interpretation of a word, taking into account its context.
   It can take the interpretation from a dictionary (like KRNNT), but it can also compute it dynamically (e.g. 
   [COMBO](https://github.com/360er0/COMBO) is a tagger that does not need a morphosyntactic analyzer).
1. The information provided by a tagger can be useful for many applications. You can selects words from particular
   grammatical category or you can submit the data to a downstream task such as text classification.
1. More sophisticated algorithms for multiword expressions identification, such as 
   [AutoPhrase](https://github.com/shangjingbo1226/AutoPhrase) take into account more features including:
   morphosyntactic tags, expression contexts, etc. and use data from e.g. Wikipedia, to automatically identify
   high-quality multiword expressions and use them to train MWE classifiers.
