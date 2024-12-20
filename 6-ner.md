# Named entity recognition

The exercise shows how we may extract elements such as names of companies, countries and similar objects from text.

## Tasks

Objectives (8 points):

1. Read the API of [NER](https://spacy.io/api/entityrecognizer) in Spacy
1. Take 1 thousand random passages from the FIQA-PL corpus.
1. Use the lemmatized and sentence split documents (using SpaCy API for [lemmatization](https://spacy.io/api/lemmatizer) and [sentence splitting](https://spacy.io/api/sentencizer)) to identify the expressions that consist of consecutive
   words starting with a capital letter (you will have to look at the inflected form of the word to check its
   capitalization) that do not occupy the first position in a sentence. E.g. the sentence:
   ```
   Wczoraj w Krakowie miało miejsce spotkanie prezydentów Polski i Stanów Zjednoczonych.
   ```
   should yield the following entries: `Kraków`, `Polska`, `Stan Zjednoczony`.
1. Compute the frequency of each identified expression and print 50 results with the largest number of occurrences.
1. Apply the NER from SpaCy to identify the named entities in the same set of documents.
1. Plot the frequency (histogram) of the identified classes.
1. Display 10 most frequent Named Entities for each identified type.
1. Display 50 most frequent Named Entities including their count and type.
2. Display 5 sentences containing at least 2 recognized named entities with different types. Highlight the recognized spans with color.
   (For demo application [Streamlit](https://streamlit.io/) might be useful for displaying NER results).


Answer the following questions (2 points):

1. Which of the method (counting expressions with capital letters vs. NER) worked better for the task concerned with
  identification of the proper names?
1. What are the drawbacks of the method based on capital letters?
1. What are the drawbacks of the method based on NER?
1. Which of the coarse-grained NER groups has the best and which has the worst results? Try to justify this
  observation.
1. Do you think NER is sufficient for identifying different occurrences of the same entity (i.e. consider "USA" and
  "Stany Zjednoczone" and "Stany Zjednoczone Ameryki Północnej")? If not, can you suggest an algorithm or a tool that
  would be able to group such names together?
1. Can you think of a real world problem that would benefit the most from application of Named Entity Recognition
  algorithm?

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
1. The set of classes used in NER is partially task dependent. Some general classes such as names of people or cities
   are used universally, but categories such as references to law regulations is specific to legal information systems.
