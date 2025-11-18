# Laboratorium 7: Wyszukiwanie hybrydowe 



## 1. Cele zajęć

Po tym laboratorium zrozumiesz:
1. Dlaczego wyszukiwanie wektorowe nie wystarcza (akronimy, identyfikatory, skróty, nazwy własne, daty, numery faktur…).
3. Na czym polega Rank Fusion (RRF) i dlaczego nie łączymy list wyników „na oko”.
4. Dlaczego potrzebujemy dwóch zapytań (Qdrant → semantyka, ES → słowa kluczowe + filtry).
5. Jak przygotować dane i metadane w sposób RAG-friendly.
6. Jak już teraz zacząć myśleć o wzbogacaniu zapytań i self-querying.

W ramach laboratorium zaprojektujesz system, który znajdzie zagadkowe dokumenty, których rozwinięcie / dosłowna treść *nie występuje literalnie w tekście*, ale musi zostać *odgadnięte* w oparciu o semantykę + klucze językowe.  



## 2. Wprowadzenie — DLACZEGO HYBRYDA?

Ustaliliśmy już, że embeddingi radzą sobie świetnie z parafrazami, ale mają poważne problemy z niektórymi zagadnieniami:

| Problem                 | Przykłady            | Semantyczne wyszukiwanie (E5) | Full-text (BM25) |
| ----------------------- | -------------------- | ----------------------------- | ---------------- |
| Akronimy                | „PAN”, „UW”, „AI”    | nie działa                    | działa           |
| Numery seryjne          | ISBN, „2024-DF-3871” | nie działa                    | działa           |
| Imiona własne           | „Dąbrówka”, „Nowak”  | częściowo                     | działa           |
| Bardzo krótkie hasła    | „psyche”, „żółć”     | nie działa                    | działa           |
| Dokładne frazy / cytaty | Fuzzy                | match_phrase                  | działa jak złoto |



Dlatego powstało wyszukiwanie hybrydowe — łączymy listy wyników z dwóch silników, najlepiej po dokładnie tym samym źródle danych (ID).



## 3. Czego potrzebujesz do pracy

Masz już korpus. To dużo. Potrzebne będą ponadto:

- ElasticSearch  FTS (BM25, Morfologik) i `dense_vector`,
- Qdrant,
- Python 3.10+.

       ┌───────────────┐        ┌───────────────┐
       zapytanie →│ Qdrant │ │ ElasticSearch │← zapytanie 2 (keywords)
    (j. naturalny)│(semantycznie) │ │ (full-text) │
    └───────────────┘ └───────────────┘
    │ │
    └───── dwie listy wyników ───────┐
    ↓
    Rank Fusion (RRF) <──────┘
    │
    ↓
    TOP-k dokumentów
Tak działamy. Ale jak to?



### 4.1. Dwa zapytania?

| Do Qdranta:                     | Do ElasticSearcha:              |
| ------------------------------- | ------------------------------- |
| „query: ludzie pracujący razem” | `"ludzie" OR "praca zespołowa"` |
| naturalne zdanie / opis         | słowa kluczowe / filtrowanie    |

Tak — potrzebujemy dwóch zapytań, bo embedding nie zna polskiej fleksji tak dobrze jak Morfologik i nie radzi sobie z akronimami / numerami seryjnymi.



## 5. Przygotowanie danych 

Stwórz dwa indeksy:

### Qdrant:

```json
collection: culturax_semantic
vector: [384 floats]
payload: { id, text, author, domain, date, topic }
```

### ElasticSearch:
- musi zawierać:
  - `text: text` (analizator `pl_lemma`),
  - `vector: dense_vector`,
  - `author, date, domain` do filtrowania

Dane muszą mieć to samo `id` w dwóch silnikach — to jest klucz do sukcesu.



## 6. Ćwiczenie 1 — **Pierwszy prototyp hybrydowy**

### 6.1. Zadanie:
Weź 10 różnych zapytań:
1. Bardzo krótkie hasła: „zespół”, „Królikowska”, „AI”
2. Parafrazy tematyczne: „jak ludzie tworzą zespoły”, „co wpływa na karierę”
3. Zapytania z liczbą / rokiem: „raport 2021”, „wydarzenia 2024”
4. Akronimy / dziwne identyfikatory: „PAN”, „LP-78”

Dla każdego:
1. stwórz dwa zapytania (jedno semantyczne, jedno „keywordowe”)
2. uruchom Qdrant + ES
3. połącz je Rank Fusion (RRF):

```json
score = (1 / rank_qdrant) + (1 / rank_es)
```

4. wypisz TOP-5 i skomentuj:
- czy hybryda dała sensowniejsze wyniki niż tylko Qdrant?

### 6.2. Tabela (do raportu):

| Zapytanie | Typ  | Top3: Qdrant | Top3: ES | Top3: HYBRYDOWE | Komentarz (kto wygrał?) |
| --------- | ---- | ------------ | -------- | --------------- | ----------------------- |

Jeśli nie współpracujesz z tabelami, można inaczej przedstawić wynik ten, ważne żeby wszystkie informacje były zawarte w takim podsumowaniu.



## 7. Ćwiczenie 2 — **Wpływ WAGI hybrydy**

Scoring nie ma znaczenia. Tak mówią ci z małymi scorami. 

Zmodyfikuj ranking:

```jsonscore = (2 / rank_qdrant) + (1 / rank_es)
 score = (1 / rank_qdrant) + (3 / rank_es)
 score = (10 / rank_qdrant) + (1 / rank_es)
```

> Kiedy BM25 jest potrzebny?  Kiedy się sprawdza?
> Czy można ustawić wagę automatycznie? – spróbuj!  (np. mierząc `cosine_sim(query_embedding, doc_embedding)` jako wskaźnik „pewności semantycznej”).



## 8. Ćwiczenie 3 – **Ablacja: co się stanie, gdy…**

Sprawdź trzy niepożądane sytuacje:

| Sytuacja                                                     | Hipoteza                               | Czy wynik hybrydy pomaga? |
| ------------------------------------------------------------ | -------------------------------------- | ------------------------- |
| Zapytań z błędem ortograficznym                              | embedding zgubi, BM25 fuzzy może pomóc | ?                         |
| Zapytania o konkretne dane („ISBN: 978...”)                  | Qdrant nie zadziała                    | ES na 1. miejscu          |
| Zapytania abstrakcyjne („co myśli autor X o odpowiedzialności?”) | Qdrant może trafić w temat             | ES nie odpowie            |

Twoje zadanie to udowodnić albo obalić powyższe hipotezy.



## 9. Ćwiczenie 4 – **Wzbogacanie zapytań → Self-Querying**

Weź 3 zapytania ogólne (np. „co tam?” / „opowiedz mi coś o technologii”).

Następnie:
1. Przepuść je przez LLM z promptem (sam zaprojektuj prompt, w którym prosisz model o to, by wygenerował 3 zapytania, które pomogą znaleźć coś w bazie danych).
2. Uruchom hybrydę na wszystkich tych zapytaniach.
3. Złącz wyniki RRF globalnie.

Czy wyniki są lepsze niż wcześniej?



## 10. Raport końcowy

Znajdź w korpusie dokumenty, które NIE zawierają słowa ‘odpowiedzialność’, ale *opisują ideę odpowiedzialności* (bez tego słowa)! Tu polegam na kreatywności i wyszukiwaniu, w Waszych korpusach może chodzić o inne słowa, których w tekście nie ma, ale wiadomo, że o nie chodzi.

### Musisz:
1. Zaprojektować strategię:
   - jak zbudować zapytania pomocnicze (w przypadku odpowiedzialności, zapytać o przejmowanie inicjatywy, poczuwanie się do konsekwencji, stabilność i to, że można na kimś polegać, na przykład),
   - jak wyciągnąć dokumenty potencjalnie pasujące,
2. Uruchomić hybrydę,
3. Odfiltrować dokumenty, które literalnie zawierają „odpowiedzial-”,
4. Znaleźć min. 5 dokumentów, które:
   - nie zawierają tego słowa,
   - ale SPRAWIAJĄ WRAŻENIE, że mówią o odpowiedzialności.
5. Napisać prompt:

```json
Czy poniższy dokument mówi O ODPOWIEDZIALNOŚCI nie używając słowa "odpowiedzialność"? TAK/NIE + dlaczego.
<doc1>...</doc1>
```

6. Zaproponować jak to wykorzystać w RAG-u:

np. „tematyczne klastry moralności”, „mapa wartości autora”, itp.

Najlepsze prace zostaną omówione jako przypadki graniczne semantyki i hybrydy.  
Dodatkowe plusy: pokaż wizualizację (np. UMAP) podobieństw między dokumentami dot. moralności.



## 11. Pytania do raportu

1. Co to jest Rank Fusion (RRF) i dlaczego używamy odwrotności pozycji?
2. Jakie kategorie zapytań wymagają mocnego BM25?
3. W których przypadkach embeddingi są ważniejsze?
4. Co by się wydarzyło, gdybyś:
- miał tylko Qdrant,
- miał tylko ES?
5. Jak rozpoznać, że zapytanie jest „abstrakcyjne”?
6. Kiedy wprowadzić Self-Querying a kiedy nie?
7. Jak zaprojektować model metadanych, by wspierał hybrydę + RAG?