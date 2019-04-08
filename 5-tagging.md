# Morphosyntactic tagging

Morphosyntactic tagging is one of the core algorithms in NLP. It assigns morphological
and (in some languages) syntactic tags to the words in a text. E.g. this allows to distinguish
between the major grammatical categories, such as nouns and verbs.


## Tasks

1. Download [docker image](https://hub.docker.com/r/djstrong/krnnt2) o KRNNT2. It includes the following tools:
   1. Morfeusz2 - morphological dictionary
   1. Corpus2 - corpus access library
   1. Toki - tokenizer for Polish
   1. Maca - morphosyntactic analyzer
   1. rknnt - Polish tagger
1. Use the tool to tag and lemmatize the corpus with the bills.
1. Using the tagged corpus compute bigram statistic for the tokens containing:
   1. lemmatized, downcased word
   1. morphosyntactic category of the word (noun, verb, etc.)
1. Exclude bigram containing non-words (such as numbers, interpunction, etc.)
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
1. Select top 50 results including noun at the first position and noun or adjective at the second position.

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
   [COMBO](https://github.com/360er0/COMBO) is a tagger that does not need a morphosyntactic ananlyzer).
1. The information provided by a tagger can be useful for many applications. You can selects words from particular
   grammatical category or you can submit the data to a downstream task such as text classification.

