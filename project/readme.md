Your task is to design and implement 2 algorithms. These algorithms should either:
1. group keyphrases
2. extract keyphrases from a document

At least one of the designed algorithms needs to be a grouping algorithm, an extracting algorithm is not required.


The grouping algorithm is given the number of sets of keyphrases, each set describes one document. Additionaly it may be given those documents (it is up to you to decide). The task is to output groups of keyphrases that are to be merged together and what keyphrase should they be merged into. E.g. \["nuclear energy", "wind energy", "energy"\] -> "energy" or \["wind energy", "hydropower", "solar energy"\] -> "renewable energy sources" (the second example is more difficult to achieve). The algorithm may use any publicly available data or tools, e.g. word embeddings, language models, onthologies or dictionaries.

The extracting algorithm is given a set of documents and should output a set of sets of phrases (one set of phrases per document) that best describe (summarize) the document content. Those phrases should be present in the document. Lemmatization of the keyphrases is optional. Additionaly the algorith should rank those phrases, meaning that the phrase more important for the document (better describing its content) should be given higher score. E.g. in the article about Orlen-Lotos merger, the companies names would probably score higher than names of the CEOs, while the names of people quoted in the article could not be extracted as keywords at all. The algorithm may or may not process one document at a time. The algorithm may use any publicly available data or tools, e.g. word embeddings, language models, onthologies or dictionaries


Attachments:
 - sample text corpus
 - keyphrases assigned to each document by some algorithm. Please note, that those phrases may not be present in the document, thus not fulfiling the requirement of being extractive keyphrases.
