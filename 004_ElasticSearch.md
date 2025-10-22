# Laboratorium 4: Full-Text Search z ElasticSearch

### 

## 1. Cel zajęć

1. Poznanie zasad działania pełnotekstowego wyszukiwania (Full-Text Search).
2. Uruchomienie lokalnej instancji ElasticSearch z wtyczką Morfologik dla języka polskiego.
3. Indeksowanie próbek korpusu OSCAR-PL (z Lab 3).
4. Eksperymenty z synonimami, lematyzacją i fleksją nazw własnych oraz wyszukiwaniem złożonym.
5. Porównanie skuteczności RegExp i FTS oraz przygotowanie gruntu pod Hybrid Search (FTS + LLM).



## 2. Przygotowanie środowiska

### 2.1. Wymagania

- Docker lub Docker Desktop
- `curl` / Kibana / Postman
- (opcjonalnie) Python z `requests`
- próbka oczyszczonego korpusu OSCAR-PL (min. 500-1000 zdań)



## 3. Uruchomienie ElasticSearch

### **Opcja A – Dockerfile**

Utwórz plik `Dockerfile`:

```
FROM docker.elastic.co/elasticsearch/elasticsearch:8.19.4
RUN elasticsearch-plugin install --batch \
  pl.allegro.tech.elasticsearch.plugin:elasticsearch-analysis-morfologik:8.19.3
ENV discovery.type=single-node
ENV xpack.security.enabled=false
```

Budowa i start:

```
docker build -t es-morfologik:8.19.4 .
docker run --rm -d --name elastic -p 9200:9200 es-morfologik:8.19.4
```



### **Opcja B – docker compose**

**Struktura katalogu**

```
.
├─ Dockerfile
└─ docker-compose.yml
```

**Zawartość pliku `docker-compose.yml`:**

```
services:
  elasticsearch:
    build: .
    ports:
      - "9200:9200"
    environment:
      - discovery.type=single-node
      - xpack.security.enabled=false
```

Uruchom:

```
docker compose up -d --build
```



### 3.1. Weryfikacja instalacji

Po uruchomieniu:

```
curl -s localhost:9200/_cat/plugins?v
```

Oczekiwany wynik: w kolumnie `component` pojawi się `analysis-morfologik`.



## 4. Tworzymy indeks i analizatory dla języka polskiego

```
PUT /oscar_pl
{
  "settings": {
    "analysis": {
      "filter": {
        "pl_month_syn": {
          "type": "synonym",
          "synonyms": [
            "styczeń, sty, i",
            "luty, lut, ii",
            "marzec, mar, iii",
            "kwiecień, kwi, iv",
            "maj, v",
            "czerwiec, cze, vi",
            "lipiec, lip, vii",
            "sierpień, sie, viii",
            "wrzesień, wrz, ix",
            "październik, paź, paz, x",
            "listopad, lis, xi",
            "grudzień, gru, xii"
          ]
        },
        "pl_morfologik": { "type": "morfologik_stem" }
      },
      "analyzer": {
        "pl_syn_lemma": {
          "tokenizer": "standard",
          "filter": ["lowercase", "pl_month_syn", "pl_morfologik", "lowercase"]
        },
        "pl_lemma": {
          "tokenizer": "standard",
          "filter": ["lowercase", "pl_morfologik", "lowercase"]
        }
      }
    }
  },
  "mappings": {
    "properties": {
      "text_syn": { "type": "text", "analyzer": "pl_syn_lemma" },
      "text_lem": { "type": "text", "analyzer": "pl_lemma" },
      "date":     { "type": "date" }
    }
  }
}
```



## 5. Wczytanie danych testowych

```
POST /oscar_pl/_bulk
{ "index": {} }
{ "text_syn": "W kwietniu 2025 w Warszawie odbyła się konferencja AI.", "text_lem": "W kwietniu 2025 w Warszawie odbyła się konferencja AI.", "date": "2025-04-12" }
{ "index": {} }
{ "text_syn": "Psu podano lek. Człowiek lubi psy, ale człowieka pies czasem nie słucha.", "text_lem": "Psu podano lek. Człowiek lubi psy, ale człowieka pies czasem nie słucha.", "date": "2025-03-03" }
{ "index": {} }
{ "text_syn": "W IV 2024 zorganizowano hackathon.", "text_lem": "W IV 2024 zorganizowano hackathon.", "date": "2024-04-10" }
{ "index": {} }
{ "text_syn": "Profesor Dąbrówki opublikował artykuł o semantyce.", "text_lem": "Profesor Dąbrówki opublikował artykuł o semantyce.", "date": "2024-11-21" }
{ "index": {} }
{ "text_syn": "Zespół badawczy pod kierunkiem Dąbrówki analizował dane językowe.", "text_lem": "Zespół badawczy pod kierunkiem Dąbrówki analizował dane językowe.", "date": "2025-01-15" }
{ "index": {} }
{ "text_syn": "Dąbrówka prowadziła wykład o lingwistyce korpusowej.", "text_lem": "Dąbrówka prowadziła wykład o lingwistyce korpusowej.", "date": "2024-12-10" }
```



## 6. Testy wyszukiwania

### 6.1. Synonimy miesięcy

```
GET /oscar_pl/_search
{
  "query": { "match": { "text_syn": "IV" } },
  "highlight": { "fields": { "text_syn": {} } }
}
```

powinno zwrócić dokument z *„kwietniu”* (synonimy: IV ↔ kwiecień)



### 6.2. Lematyzacja (fleksja rzeczowników)

```
GET /oscar_pl/_search
{
  "query": { "match": { "text_lem": "pies" } },
  "highlight": { "fields": { "text_lem": {} } }
}
```

powinno znaleźć „psu”, „psy”, „człowieka” — dzięki filtrowi `morfologik_stem`.



### 6.3. Fleksja nazwiska „Dąbrówka”

```
GET /oscar_pl/_search
{
  "query": { "match": { "text_lem": "Dąbrówka" } },
  "highlight": { "fields": { "text_lem": {} } }
}
```

zwróci wszystkie formy: „Dąbrówki”, „Dąbrówkę”, „Dąbrówką” – Morfologik rozpozna warianty fleksyjne nazw własnych.



### 6.4. Fuzziness (literówki)

```
GET /oscar_pl/_search
{
  "query": {
    "match": {
      "text_syn": { "query": "kwiecien", "fuzziness": "AUTO" }
    }
  },
  "highlight": { "fields": { "text_syn": {} } }
}
```

znajdzie dokument z *„kwietniu”* mimo braku ogonka.



### 6.5. Podgląd tokenów (API `_analyze`)

```
GET /oscar_pl/_analyze
{
  "analyzer": "pl_syn_lemma",
  "text": "Profesor Dąbrówki analizował dane w kwietniu."
}
```

Zobaczysz tokeny po lematyzacji i zamianie synonimów.



## 7. Porównanie: RegExp vs ElasticSearch

| Kryterium    | RegExp (Lab 3)                   | FTS (Lab 4)                      |
| ------------ | -------------------------------- | -------------------------------- |
| Dokładność   | 100 % tylko dla ścisłych wzorców | wysoka, uwzględnia odmiany       |
| Skalowalność | słaba przy dużych zbiorach       | bardzo dobra (inverted index)    |
| Fleksja PL   | trzeba obsługiwać ręcznie        | Morfologik robi to automatycznie |
| Synonimy     | trzeba dodać ręcznie             | obsługiwane filtrem              |
| Czas         | wolny przy > 100 kB tekstu       | milisekundy                      |



## 8. Zadania do wykonania

1. Zbuduj drugi indeks `oscar_basic` bez pluginu Morfologik i porównaj wyniki zapytań dla słowa „człowiek” oraz nazwisko występujące w korpusie na wzór „Dąbrówka”.
2. Użyj `_termvectors`, by porównać liczbę tokenów w obu wersjach indeksu.
3. Zmierz liczbę trafień dla:
   - `match: "człowiek"`
   - `match: "ludzie"`
   - `match: dowolne nazwisko z korpusu na wzór "Dąbrówka"`
4. Zapisz obserwacje w tabeli (Precision/Recall).
5. Odpowiedz: które przypadki Morfologik rozwiązuje najlepiej, a gdzie zawodzą RegExpy z Lab 3?



## 9. Pytania kontrolne

1. Co robi filtr `morfologik_stem` i czym różni się od analizatora `morfologik`?
2. Dlaczego warto dodać `lowercase` po lematyzacji?
3. Jak w ES realizowana jest koncepcja inverted index?
4. W jakich sytuacjach fuzzy search działa lepiej niż synonimy?
5. Jak w ES można wyszukiwać frazy? Zastosuj jeden z możliwych sposobów i przygotuj wyniki wyszukiwania dla 5 różnych fraz. Czy wyszukiwanie zależy od fleksji elementów składowych frazy?
6. Jak połączyć FTS z LLM w systemie typu RAG? (tu oczekuję tylko propozycji, nie gotowego kodu)



## 10. Zadania do raportu (8-10)

1. Załaduj 10 000 zdań z korpusu OSCAR-PL.
2. Zbuduj indeks `oscar_morfologik` z pełnym analizatorem (jak wyżej).
3. Przeprowadź zapytania dla grup semantycznych:
   - *człowiek/ludzie/ludzkość*
   - *pies/psu/psami*
   - dowolne nazwisko występujące w korpusie
4. Porównaj wyniki między analizatorem prostym a Morfologikiem.
5. Porównaj P@10 dla:
        a) czystego matcha,
        b) match_phrase+slop,
        c) function_score z recency.
6. Poeksperymentuj: dorzuć do analizatora pole z lematami i sprawdź wpływ na wyszukiwanie fraz.
7. Przygotuj raport (1 strona) z komentarzem: **kiedy FTS z lematyzacją PL wygrywa z RegExp?**



### Miejsca do zajrzenia:

1. Dokumentacja ES: https://www.elastic.co/docs/reference/elasticsearch/
2. Analizator Morfologik: https://github.com/allegro/elasticsearch-analysis-morfologik
3. Odległość edycyjna Levenshteina: https://en.wikipedia.org/wiki/Levenshtein_distance oraz https://en.wikipedia.org/wiki/Levenshtein_automaton

