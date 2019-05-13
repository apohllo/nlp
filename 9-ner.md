# Named entity recognition

The exercise shows how we may extract elements such as names of companies, countries and similar objects from text.

## Tasks

1. Read the classification of [Named Entities](http://clarin-pl.eu/pliki/warsztaty/Wyklad3-inforex-liner2.pdf).
1. Read the [API of NER](http://nlp.pwr.wroc.pl/redmine/projects/nlprest2/wiki) in [Clarin](http://ws.clarin-pl.eu/ner.shtml).
1. Read the [documentation of CLL format](http://nlp.pwr.wroc.pl/redmine/projects/corpus2/wiki/CCL_format).
1. Randomly select 100 bills.
1. Recognize the named entities in the documents using the `n82` model.
1. Plot the frequency of the recognized classes:
   1. fine-grained classification histogram (classes such as `nam_fac_bridge`, `nam_liv_animal`).
   1. coarse-grained classification histogram (classes such as `nam_adj`, `nam_eve`, `nam_fac`).
1. Display 50 most frequent Named Entities including their count and fine-grained type.
1. Display 10 most frequent Named Entities for each coarse-grained type.
1. Discuss the results of the extraction.

## Hints

1. Named entity recognition is a process aimed at the identification of entities mentioned in text by determining their
   scope and classifying them to a predefined type. The larger the number of types, the more difficult the problem is.
1. Named entities are usually proper names and temporal expressions. They usually convey the most important information
   in text.
1. IOB format is typically used to tag names entities. The name (IOB) comes from the types of tokens (_in_, _out_, _beginning_).
   The following example shows how the format works:
   ```
   W            O
   1776         B-TIME
   niemiecki    O
   zoolog       O
   Peter        B-PER
   Simon        I-PER
   Pallas       I-PER
   dokonał      O
   formalnego   O
   ...
   ```
1. The set of classes used in NER is partially task dependant. Some general classes such as names of people or cities
   are used universally, but categories such as references to law regulations is specific to legal information systems.
