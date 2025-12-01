# **Laboratorium 8: RAG -- Retrieval jako rozszerzenie wyszukiwania**



## 1. Cele zajęć:

1. Zrozumienie RAGa jako rozszerzenia wyszukiwania hybrydowego.

2. Budowanie minimalnego pipeline’u RAG bez frameworków.

3.  Analiza zapytań i rozpoznawanie ich typów.

4. Zaprojektowanie retrievalu (Qdrant + ElasticSearch) jako fundamentu RAGa:

   - tworzenie promptu RAG z kontekstu wyszukiwania

   - wykorzystywanie chunkingu w celu kontroli długości promptu

------

## 2. Etap 1 – RAG „na piechotę”

### Zadanie 1 – funkcja bazowa

```
def rag_query(user_input):
    # analiza zapytania
    # retrieval (Qdrant i ES)
    # fusion RRF
    # selekcja dokumentów
    # chunking
    # konstrukcja promptu
    # odpowiedź LLM
```

### Zadanie 2 – test na 10 zapytaniach

Wykorzystujemy zapytania z Lab 6 i Lab 7 oraz nowe:

| Zapytanie                               | Typ przewidywany |
| --------------------------------------- | ---------------- |
| Czym jest praca zespołowa?              | semantyczne      |
| PAN                                     | akronim          |
| LP-78                                   | id dokumentu     |
| Jak pokonać kryzys zaufania?            | abstrakcyjne     |
| Czy inflacja 2022 była wyższa niż 2021? | factual          |
| Co Sinek mówił o liderach?              | filtr: autor     |
| Dąbrówka badania nad językiem           | metadane         |
| Ludzie działający razem                 | parafraza        |
| Jakie dokumenty o klimacie po 2020?     | dwuwątkowe       |
| Co to odpowiedzialność moralna?         | semantyczne      |

Wynik musi zawierać:

```
- dokumenty użyte w prompcie,
- wygenerowaną odpowiedź,
- uzasadnienie, które źródła są najbardziej trafne.
```

------

## 4. Etap 2 – selekcja kontekstu (context window)

### Zadanie 1 – chunking

```
def chunk_document(text, tokens=200):
    # dzielenie dokumentu na fragmenty o max 200 tokenach
```

### Zadanie 2 – eksperyment

| Scenariusz                | Oczekiwanie                  |
| ------------------------- | ---------------------------- |
| 1 fragment (200 tokenów)  | odpowiedź poprawna           |
| 3 fragmenty (500 tokenów) | możliwe pominięcie kontekstu |
| 5 fragmentów (1000+)      | model może halucynować       |

Należy zapisać obserwacje:

- które fragmenty model ignoruje?
- czy cytuje źródło?
- czy pojawiają się halucynacje?

------

## 5. Etap 3 – konstruowanie promptu

Należy stworzyć minimum 2 warianty promptu:

### Wersja A (prosta)

```
Odpowiedz na pytanie, używając wyłącznie poniższych fragmentów:

[1] ...
[2] ...

Pytanie:
...
```

### Wersja B (bardziej restrykcyjna)

```
Odpowiedz wyłącznie na podstawie fragmentów poniżej.
Jeśli nie znajdziesz odpowiedzi, napisz: "BRAK INFORMACJI".
Dodaj cytat potwierdzający odpowiedź.

Frag.:
[1] ...
[2] ...

Pytanie:
...
```

Uwaga: to tylko przykładowe prompty.

**Porównanie**:

- czy model używa cytatów?
- czy halucynuje?
- która wersja jest bardziej stabilna?

------

## 6. Zadanie domowe 

to stworzenie pełnego raportu eksperymentalnego, który zawiera:

- opis pipeline’u
- test na min. 10 zapytaniach
- analizę chunkingu
- wnioski z różnych promptów z uwzględnieniem zadań gramatycznych i semantycznych (mogą to być przykłady z labów 6 i 7)
- ocena `0-2` dla każdej odpowiedzi (jakość / źródła / błędy) -- ocena jak w labie 6.