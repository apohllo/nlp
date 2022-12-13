# Project description

Your task is to design and implement 2 algorithms (or 4 algorithms if you work in a pair). These algorithms should either:
1. group keyphrases,
2. extract keyphrases from a document.

At least one of the designed algorithms needs to be a grouping algorithm, an extracting algorithm is not required.
Both algorithms should consider Polish as the target language.

## Keyphrase grouping

The grouping algorithm is given a number of lists of keyphrases, each list describes one document. 
Additionaly it may be given those documents (it is up to you to decide). The task is to output partitions of keyphrases that
should be merged together and the reference keyphrase they be merged into. E.g. `["nuclear energy", "wind energy",
"energy"] -> "energy"` or `["wind energy", "hydropower", "solar energy"] -> "renewable energy sources"` (the second
example is more difficult to achieve). The algorithm may use any publicly available data or tools, e.g. word embeddings,
language models, onthologies or dictionaries.


## Keyphrase extraction

The extracting algorithm is given a set of documents and should output a set of lists of phrases (one list of phrases per
document) that best describe (summarize) the document content. Those phrases should be present in the document.
Lemmatization of the keyphrases is optional. Additionaly the algorith should rank those phrases, meaning that the phrase
more important for the document (better describing its content) should be given higher score. E.g. in the article about
Orlen-Lotos merger, the companies names would probably score higher than names of the CEOs, while the names of people
quoted in the article could not be extracted as keywords at all. The algorithm may or may not process one document at a
time. The algorithm may use any publicly available data or tools, e.g. word embeddings, language models, onthologies or
dictionaries


## Resources

* [sample text corpus](https://github.com/the-ultimate-krol/spacex),
* keyphrases assigned to each document by some algorithm. Please note, that those phrases may not be present in the
  document, thus not fulfiling the requirement of being extractive keyphrases,
* a reference algorithm extracting keypharses from documents in Polish: https://huggingface.co/Voicelab/vlt5-base-keywords
