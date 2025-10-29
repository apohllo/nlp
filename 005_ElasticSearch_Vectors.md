# Laboratorium 5: Wektoryzacja w Elastic Search

## 1. Cele zajęć

1. Wyjaśnienie pojęć: 

   - embedding/wektor, 

   - wymiar (dims), 

   - normalizacja L2, 

   - cosine vs dot product, 

   - kNN, 

   - HNSW, 

   - `**dense_vector**`, 

   - `**knn**` query, 

   - `**k**` 

     i `**num_candidates**`.

2. Przygotowanie polskiego mini‑korpusu CulturaX (PL) do dalszej pracy: krótkie pasaże, czyste, bez duplikatów.

3. Wygenerowanie embeddingów (E5) dla dokumentów i (na żądanie) dla zapytań.

4. Utworzenie indeksu ES z polem `**dense_vector**` i zindeksowanie dokumenty z wektorami.
5. Wykonanie i zinterpretowanie zapytania kNN w ES (uwzględniając parametry i pułapki).

## 2. Słowniczek pojęć 

- Embedding / wektor: liczbowy opis znaczenia tekstu.
- Normalizacja L2: skalowanie tak, by ∥x∥2=1\|x\|_2=1∥x∥2=1. Daje cosine(x,y)=x·y, więc można użyć iloczynu skalarnego jako miary podobieństwa.
- kNN: znajdowanie k najbliższych sąsiadów. W ES używamy przybliżonego kNN na strukturze HNSW.
- `**dense_vector**`: typ pola w ES do trzymania wektora; musi znać `**dims**` i `**similarity**` (u nas: `cosine`).
- `**knn**` query (ES): zapytanie wektorowe. Kluczowe parametry: `k` (ile wyników chcemy) i `num_candidates`.
- Konwencja oznaczania z modelu E5: `**passage: …**` dla dokumentów, `**query: …**` dla zapytań — ważne dla jakości, bo model był tak uczony.

## 3. Środowisko i dane (CulturaX‑PL)

Wymagania: Python 3.10+, `sentence-transformers`, `torch`, `requests`, `tqdm`; ElasticSearch 8.19.x (single‑node, bez security) + `analysis‑morfologik` dla pól leksykalnych (przyda się później).

Dane: przygotuj `data/culturax_pl_clean.jsonl` — każdy wiersz: `{ id, text, domain?, date? }`.
Minimalne kroki czyszczenia (bez wklejek kodu):

1. filtr językowy → tylko PL; 2) usunięcie HTML/boilerplate; 3) usunięcie URL i zbędnych białych znaków; 4) dedup (hash + near‑dup ~0.8); 5) segmentacja na pasaże 2–5 zdań (120–700 znaków); 6) zachowaj `domain/date` jeśli są.

## 4. Tworzenie wektorów (embeddingów) — **krok po kroku**

**Model**: `intfloat/multilingual-e5-small` (384D) — szybki i dobry dla PL; alternatywnie `…-base` (768D).

**Kroki**:

1. Załaduj model (SentenceTransformers).
2. Dokumenty embeduj jako `**passage: {text}**`.
3. Włącz `**normalize_embeddings=True**` → każdy wektor ma L2≈1.
4. Zapisz wektor obok dokumentu (np. dodaj klucz `vector:[…]`).
5. Sprawdź jakość na 20 losowych par: czy parafrazy/tematy bliskie mają wyższy cosinus?



## 5. Indeks w ElasticSearch z polem `dense_vector` (jedyna wklejka techniczna)

Dostosuj `dims` do swojego modelu (384 lub 768):

PUT /culturax_vectors

{

  "settings": {

​    "analysis": {

​      "analyzer": {

​        "pl_lemma": {

​          "tokenizer":"standard",

​          "filter":["lowercase"]

​        }

​      }

​    }

  },

  "mappings": {

​    "properties": {

​      "id":     {"type":"keyword"},

​      "domain": {"type":"keyword"},

​      "date":   {"type":"date"},

​      "text":   {"type":"text","analyzer":"pl_lemma"},

​      "vector": {"type":"dense_vector","dims":384,"index":true,"similarity":"cosine"}

​    }

  }

}

**Wyjaśnienie**:

- `vector.index: true` + `similarity: cosine` → ES zbuduje wewnętrzne struktury HNSW do kNN.

- `text` zostawiamy do debugowania i przyszłych labów (BM25/analizatory PL).

- `domain/date` przydadzą się do filtrowania/analizy (np. świeżość).

  

## 6. Indeksacja: jak „włożyć” tekst i wektor do ES

Co przygotować: plik NDJSON do BULK, gdzie pary linii to akcja i dokument:

{ "index": { "_index": "culturax_vectors", "_id": "<id>" } }

{ "id": "<id>", "text": "<krótki pasaż>", "domain": "<domena>", "date": "<YYYY-MM-DD>", "vector": [ <384 liczb float> ] }



Dobre praktyki:

- partiami po 1–2 tys. linii;
- po każdym BULK sprawdź `"errors": false`;
- na końcu `/_count` ≈ licznie rekordów wejściowych;
- jeśli dostaniesz błąd „`dims mismatch`” → upewnij się, że `**dims**` = wymiar modelu.



## 7. Zapytania kNN w ElasticSearch (co, jak i dlaczego)

1. Embedding zapytania: wygeneruj w momencie zapytania wektor `query: …` (L2≈1).
2. Parametry `**knn**`:**

- `k` — ile wyników zwracamy (np. 10, 20).
- `num_candidates` — ilu kandydatów kNN przejrzy przed zwróceniem `k`; większa wartość → zwykle lepsza jakość, ale wolniej (np. 200–1000).

3. Przykładowe zapytanie (schemat):

GET /culturax_vectors/_search

{

  "knn": {

​    "field": "vector",

​    "query_vector": [ /* embedowane `query:` */ ],

​    "k": 20,

​    "num_candidates": 400

  },

  "size": 10,

  "_source": ["id","text","domain","date"]

}

4. Jak czytać wynik: ES zwraca `score` oparte o podobieństwo (dla znormalizowanych wektorów — zbieżne z cosinusem). Sprawdź, czy Top‑1/Top‑3 „tematycznie pasują”.

5. Typowe pułapki:

- brak prefiksu `query:`/`passage:` w E5 → spadek jakości;

- brak normalizacji → wyniki przypadkowe/uprzedzone długością;

- zbyt małe `num_candidates` → „dziwne” pominięcia;

- zbyt długie pasaże → wektor miesza wiele tematów (segmentuj krócej).

  

## 8. Kiedy pracujesz, sprawdź kilka rzeczy:

1. Sanity‑check embeddingów: wybierz 10 pasaży, policz wektory `passage:` i sprawdź „na papierze” (intuicyjnie), które do których są podobne — porównaj z Top‑3 kNN dla 3 różnych zapytań `query:`.
2. Wpływ prefiksów E5: raz embeduj zapytania bez `query:`, raz z — które Top‑3 są sensowniejsze? Zapisz 2 przykłady różnicy.
3. Parametry kNN: porównaj `num_candidates` = 100 vs 400 vs 1000 (czas i jakość subiektywna wyników) dla 5 zapytań.
4. Segmentacja: połącz dwa sąsiednie pasaże w jeden długi i porównaj ranking – co się zmienia?

## 9. Zadanie domowe

Cel: zrozumieć kompromisy jakości/czasu w wyszukiwaniu wektorowym w samym ES.

1. Przygotuj 10 zapytań (PL) w trzech kategoriach:
   - parafrazy (np. „Jakie wydarzenia AI odbyły się w Warszawie w kwietniu?”),
   - nazwy własne/terminy (np. konkretne osoby, instytucje),
   - zapytania szumne (mało treściwe, ogólne).
2. Dla każdego zapytania uruchom `knn` z: `k ∈ {10, 20}` oraz `num_candidates ∈ {100, 400, 1000}`.
3. Ręcznie oznacz ≥5 relewantnych dokumentów/zapytanie (z waszego indeksu) i policz P@10.
4. Zmierz latencję (uśrednij 5 powtórzeń) i narysuj mini‑wykres: jakość (P@10) vs czas (ms).
5. Wnioski:
   - Jaki `num_candidates` daje najlepszy kompromis?
   - Gdzie kNN radzi sobie gorzej? (np. bardzo krótkie zapytania/hasła, wieloznaczność)
   - Jak długość pasaży wpływa na wyniki?

6. Dlaczego po normalizacji L2 iloczyn skalarny ≡ cosinus?

7. Co oznacza wymiar `**dims**` i czemu jego zmiana wpływa na szybkość i pamięć?

8. Po co w E5 prefiksy `query:` i `passage:`?

9. Co reguluje `num_candidates` i jak wpływa na czas/jakość?

10. Dlaczego segmentacja na krótsze pasaże często poprawia wyniki?

11. Jakie są ograniczenia wyszukiwania wektorowego w ES vs silniki dedykowane (wyszczególnij 2)?



## Miejsca do zajrzenia:

- BM25 i PRF: Robertson & Zaragoza (2009) https://www.researchgate.net/publication/220613776_The_Probabilistic_Relevance_Framework_BM25_and_Beyond
- SBERT (sentence embeddings): Reimers & Gurevych (2019). https://arxiv.org/abs/1908.10084
- E5 (multilingual embeddings): Wang, Yang, Huang, Yang, Majumder, Wei (2024). https://arxiv.org/abs/2402.05672 https://huggingface.co/intfloat/multilingual-e5-large
- RRF (łączenie rankingów): Cormack, Clarke & Buettcher (2009). https://dl.acm.org/doi/10.1145/1571941.1572114
- Morfologik dla PL w ElasticSearch 

