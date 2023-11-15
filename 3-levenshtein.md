# Levenshtein distance and spelling corrections

The task introduces the Levenshtein distance - a measure that is useful in tasks such as approximate string matching.

## Tasks

Task objectives (8 points):
1. Use the corpus from exercise no. 1.
2. Use SpaCy [tokenizer API](https://spacy.io/api/tokenizer) to tokenize the text in the documents.
3. Compute **frequency list** for each of the processed files.
4. Aggregate the result to obtain one global frequency list. This frequency list gives you unigram statistics of the words
   appearing in the corpus.
5. Apply a distortion function to the queries part of the corpus. In each query draw randomly one word and change one letter
   in the word to some other letter.
6. Compute nDCG@10 for the distorted queris, using the same approach as in lab 2. This result will be the baseline
   for the other methods.
8. Install [Morfeusz](http://morfeusz.sgjp.pl/download/) (Binding dla Pythona) and use it to find all words from the queries that do not
   appear in that dictionary. Only these words should be corected in the next step.
10. Use Levenshtein distance and the frequency list, to determine the most probable correction of the words
    in the queries that were identified as invalid. (**Note**: You don't have to apply the distance directly. Any method that is more
    efficient than scanning the dictionary will be appreciated.)
11. Compute nDCG@10 for your implementation of the spelling correction method.
12. Use ElasticSearch's fuzzy match and compute nDCG@10 for this approach.
13. Compare the results of baseline with the 2 implemented methods. Take into account the nDCG score and the performance of the methods.
   
Draw conclusions regarding (2 points):
  * the distribution of words in the corpus,
  * the performance of your method compared to ElasticSearch,
  * the results provided by your method compared to ElasticSearch,
  * the validity of the obtained corrections.

## Hints

1. Levenshtein distance (Edit distance) is a measure defined for any pair of strings. It is defined as the minimal
   number of single character edits (insertions, deletions or substitutions) needed to transform one string to the
   other. The measure is symmetric.
1. The algorithm is usually implemented as a dynamic program,
   see [Wikipedia article](https://en.wikipedia.org/wiki/Levenshtein_distance) for details.
1. The distance may be used to fix an invalid word by inspecting in the growing order of the distance, the words
   that are *n* edits away from the invalid word. If there are no words *n* edits away, the words *n+1* edits away
   are inspected.
1. The frequency list may be used to select the most popular word with given distance, if there are many candidate
   corrections.
1. Usually the correction algorithm does not use the edit distance directly, since it would require to compare the
   invalid word with all words in the dictionary. The algorithms work in the opposite way - they generate candidate
   words that are 1 or 2 edits away from the invalid word (cf. P. Norvig's
   [article](https://norvig.com/spell-correct.html) for the details). A different approach is to
   use [Levenshtein automaton](https://norvig.com/spell-correct.html) for finding the corrections effectively.
1. ElasticSearch has
   a [fuzziness](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html)
   parameter for finding approximate matches of a query.
