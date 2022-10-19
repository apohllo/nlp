# Levenshtein distance and spelling corrections

The task introduces the Levenshtein distance - a measure that is useful in tasks such as approximate string matching.

## Tasks

1. Use the corpus from exercise no. 1 or any other Polish corpus of comparable size.
2. Make sure the texts in the corpus does not contain HTML code.
3. Use SpaCy [tokenizer API](https://spacy.io/api/tokenizer) to tokenize the text from the cleaned law corpus.
4. Compute **frequency list** for each of the processed files.
5. Aggregate the result to obtain one global frequency list.
6. Reject all entries that are shorter than 2 characters or contain non-letter characters (make sure to include Polish
   diacritics).
1. Make a plot in a logarithmic scale (for X and Y):
   1. X-axis should contain the **rank** of a term, meaning the first rank belongs to the term with the highest number of
      occurrences; the terms with the same number of occurrences should be ordered by their name,
   2. Y-axis should contain the **number of occurrences** of the term with given rank.
1. Install [Morfeusz](http://morfeusz.sgjp.pl/download/) (Binding dla Pythona) and use it to find all words that do not
   appear in that dictionary.
1. Find 30 words with the highest ranks that do not belong to the dictionary.
1. Find 30 random words (i.e. shuffle the words) with 5 occurrences that do not belong to the dictionary.
1. Use Levenshtein distance and the frequency list, to determine the most probable correction of the words from
   lists defined in points 8 and 9. (**Note**: You don't have to apply the distance directly. Any method that is more efficient than scanning the
   dictionary will be appreciated.)
1. Load [SGJP dictionary](http://morfeusz.sgjp.pl/download/) (Słownik SGJP dane tekstowe) to ElasticSearch (one document for each form) 
   and use fuzzy matching to obtain the possible
   corrections of the 30 words with 5 occurrences that do not belong to the dictionary.
1. Compare the results of your algorithm and output of ES. 
1. Draw conclusions regarding:
   * the distribution of words in the corpus,
   * the number of true misspellings vs. the number of unknown words,
   * the performance of your method compared to ElasticSearch,
   * the results provided by your method compared to ElasticSearch,
   * the validity of the obtained corrections.

## Hints

1. Levenshtein distance (Edit distance) is a measure defined for any pair of strings. It is defined as the minimal
   number of single character edits (insertions, deletions or substitutions) needed to transform one string to the
   other. The measure is symmetric.
1. The algorithm is usually implemented as a dynamic program, see [Wikipedia article](https://en.wikipedia.org/wiki/Levenshtein_distance)
   for details.
1. The distance may be used to fix an invalid word by inspecting in the growing order of the distance, the words
   that are *n* edits away from the invalid word. If there are no words *n* edits away, the words *n+1* edits away
   are inspected.
1. The frequency list may be used to select the most popular word with given distance, if there are many candidate
   corrections.
1. Usually the correction algorithm does not use the edit distance directly, since it would require to compare the
   invalid word with all words in the dictionary. The algorithms work in the opposite way - they generate candidate words
   that are 1 or 2 edits away from the invalid word (cf. P. Norvig's [article](https://norvig.com/spell-correct.html)
   for the details). A different approach is to use [Levenshtein automaton](https://norvig.com/spell-correct.html) for
   finding the corrections effectively.
1. ElasticSearch has a [fuzziness](https://www.elastic.co/guide/en/elasticsearch/reference/current/query-dsl-fuzzy-query.html)
   parameter for finding approximate matches of a query.
