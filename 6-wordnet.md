# Wordnet (słowosieć)

The task concentrates on the usage of a WordNet for finding semantic relations between words and expressions.

## Task

1. Read the [Wordnet API](http://api.slowosiec.clarin-pl.eu/docs/index.html)
1. Get acquainted with [semantic relations](http://nlp.pwr.wroc.pl/narzedzia-i-zasoby/narzedzia/disaster/25-wiedza/81-relacje-w-slowosieci) in WordNet.
1. Find all meaning of the _szkoda_ **noun** and display all their synonyms.
1. Find closure of **hypernymy** relation for the first meaning of the _wypadek drogowy_ expression.
   Create diagram of the relations as a directed graph.
1. Find direct **hyponyms** of _wypadek<sub>1</sub>_ noun.
1. Find second-order **hyponyms** of the same noun.
1. Display as a directed graph (with labels for the edges) semantic relations between the following groups of lexemes:
   1. szkoda<sub>2</sub>, strata<sub>1</sub>, uszczerbek<sub>1</sub>, szkoda majątkowa<sub>1</sub>, 
      uszczerbek na zdrowiu<sub>1</sub>, krzywda<sub>1</sub>, niesprawiedliwość<sub>1</sub>, nieszczęście<sub>2</sub>.
   1. wypadek<sub>1</sub>, wypadek komunikacyjny<sub>1</sub>, kolizja<sub>2</sub>, zderzenie<sub>2</sub>,
      kolizja drogowa<sub>1</sub>, bezkolizyjny<sub>2</sub>, katastrofa budowlana<sub>1</sub>, wypadek
      drogowy<sub>1</sub>.
1. Find the value of [Leacock-Chodorow semantic similarity measure](ftp://www-vhost.cs.toronto.edu/public_html/public_html/pub/gh/Budanitsky+Hirst-2001.pdf)
   between following pairs of lexemes:
   1. szkoda<sub>2</sub> - wypadek<sub>1</sub>,
   1. kolizja<sub>2</sub> - szkoda majątkowa<sub>1</sub>,
   1. nieszczęście<sub>2</sub> - katastrofa budowlana<sub>1</sub>.


## Hints

1. WordNet is a semantic dictionary that has the following features:
   1. it identifies **the meanings** of the words, i.e. _zamek_ in the sense of a _castle_ and _zamek_ in the sense of a  _tool_ have two distinct representations,
   1. it describes these meaning using **semantic relations**, e.g. _zamek<sub>1</sub>_ is a **hyponym** of
      _budynek<sub>1</sub>_ and _zamek<sub>2</sub>_ is a **hypernym** of _zatrzasku<sub>2</sub>_.
1. The meaning of a lexeme is identified by an index, e.g. _zamek<sub>1</sub>_ identifies the first meaning and
   _zamek<sub>2</sub>_ the second, etc.
1. WordNet defines **lexemes** and **synsets**. The lexemes roughly correspond to words, i.e. we say that a lexeme with
   an index _has_ a particular meaning, e.g.  _zamek<sub>2</sub>_  refers to a tool for closing things.
   But that meaning is obtained thanks to its participation to a particular _synset_. A synset is a set of lexemes that
   share meaning. E.g. _szkoda<sub>2</sub>_, _uszczerbek<sub>1</sub>_, _strata<sub>1</sub>_ and _utrata<sub>1</sub>_
   belong to one synset. As a consequence the definition and most of the relations are attached to a synset, rather than
   a lexeme. Lexemes belonging to a particular synset are called synonyms.
1. The [NLTK](https://www.nltk.org/) library has an [implementation](http://www.nltk.org/howto/wordnet.html) of Leacock-Chodorow measure, 
   but it does not integrate with the Polish WordNet.
1. The [pywnxml](https://github.com/ppke-nlpg/pywnxml) library allows for reading the Polish WordNet, but it lacks that
   measure.
1. The contents of the Polish WordNet may also be accessed by a [web API](http://api.slowosiec.clarin-pl.eu/docs/index.html)
