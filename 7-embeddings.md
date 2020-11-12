# Word embeddings

The tasks concentrates on the recent development in representing words as dense vectors in highly dimiensional spaces.

## Tasks

1. Read the documentation of [word2vec](https://radimrehurek.com/gensim/models/word2vec.html) in Gensim library.
1. Download polish word embeddings for word2vec [github/Google drive](https://github.com/sdadas/polish-nlp-resources):
   * with [100 dimensionality](https://github.com/sdadas/polish-nlp-resources/releases/download/v1.0/word2vec.zip)
   * with [300 dimensionality](https://witedupl-my.sharepoint.com/:u:/g/personal/dadass_wit_edu_pl/EbNa5QXEYU5Jnbmq8gIK72YBRiQPybNBytVh2TaUCckyJQ?e=8Qa3vs)
1. Using the downloaded models find the most similar words for the following expressions:
   1. kpk
   1. szkoda
   1. wypadek
   1. kolizja
   1. nieszczęście
   1. rozwód
1. Display 5 most similar words according to each model.
1. Find the most similar words for the following expressions (average the representations for each word):
   1. sąd najwyższy
   1. trybunał konstytucyjny
   1. szkoda majątkowy
   1. kodeks cywilny
   1. sąd rejonowy
1. Display 7 most similar words according to each model.
1. Find the result of the following equations (5 top results, both models):
    1. sąd + konstytucja - kpk
    1. pasażer + kobieta - mężczyzna
    1. pilot + kobieta - mężczyzna
    1. lekarz + kobieta - mężczyzna
    1. nauczycielka + mężczyzna - kobieta
    1. przedszkolanka + mężczyzna - 'kobieta
    1. samochód + rzeka - droga
1. Using the [t-SNE](http://scikit-learn.org/stable/modules/generated/sklearn.manifold.TSNE.html) 
   algorithm compute the projection of the random 1000 words with the following words highlighted
   (both models):
   1. szkoda
   1. strata
   1. uszczerbek
   1. krzywda
   1. niesprawiedliwość
   1. nieszczęście
   1. kobieta
   1. mężczyzna
   1. pasażer
   1. pasażerka
   1. student
   1. studentka
   1. lekarz
   1. lekarka
1. Answer the following questions:
   1. Compare results for all experiments with respect to the employed models (100 and 300-d)?
   1. Compare results for singe words and MWEs.
   1. How the results for MWEs could be improved?
   1. Are the results for albegraic operations biased?
   1. According to t-SNE: do representations of similar word cluster together?

## Hints

1. Read the classic articles:
   * [Distributed Representations of Words and Phrases and their Compositionality](http://papers.nips.cc/paper/5021-distributed-representations-of-words-andphrases)
   * [Efficient Estimation of Word Representations in Vector Space](https://arxiv.org/abs/1301.3781)
1. The word2vec algorithm uses two variants:
   1. CBOW - using the context words, the central word is predicted
   1. skip-gram - using the central word, the context words are predicted
1. The word2vec algorithm is pretty efficient. It can process a corpus containing 1 billion words in one day.
1. The vectors provided by the algorithm reflect some of the semantic and syntactic features of the represented
   words. E.e. the following equation should work in the vector space:
   `w2v("król") - w2v("mężczyzna") + w2v("kobieta") = w2v("królowa")`
