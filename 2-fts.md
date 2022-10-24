# Lemmatization and full text search (FTS)

The task is concentrated on using full text search engine (ElasticSearch) to perform basic search
operations in a text corpus.

## Tasks

1. Install ElasticSearch (ES).
1. Install an ES plugin for Polish https://github.com/allegro/elasticsearch-analysis-morfologik 
1. Define an ES analyzer for Polish texts containing:
   1. standard tokenizer
   1. synonym filter with the following definitions:
      1. kpk - kodeks postępowania karnego
      1. kpc - kodeks postępowania cywilnego
      1. kk - kodeks karny
      1. kc - kodeks cywilny
   1. Morfologik-based lemmatizer
   1. lowercase filter
1. Define an ES index for storing the contents of the legislative acts.
1. Load the data to the ES index.
1. Determine the number of legislative acts containing the word **ustawa** (in any form).
2. Determine the number of occurrences of the word **ustawa** by searching for this particular form, including the other inflectional forms.
3. Determine the number of occurrences of the word **ustaw** by searching for this particular form, including the other inflectional forms.
4. Determine the number of legislative acts containing the words **kodeks postępowania cywilnego** 
   in the specified order, but in any inflection form.
1. Determine the number of legislative acts containing the words **wchodzi w życie** 
   (in any form) allowing for up to 2 additional words in the searched phrase.
1. Determine the 10 documents that are the most relevant for the phrase **konstytucja**.
1. Print the excerpts containing the word **konstytucja** (up to three excerpts per document) 
   from the previous task.

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
