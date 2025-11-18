# Laboratorium 6: Wyszukiwanie semantyczne (Qdrant + ElasticSearch)



## 1. Cel zajęć

1. Zrozumienie praktycznego działania wyszukiwania semantycznego na embeddingach tekstu.
2. Poznanie różnic między:
   - klasycznym FTS (BM25 + Morfologik z Lab 4),
   - wyszukiwaniem wektorowym w ElasticSearch (`dense_vector`),
   - wyszukiwaniem wektorowym w Qdrant.
3. Przeanalizowanie problemów związanych za analizą języka polskiego (składni i semantyki).
4. Przygotowanie wspólnego korpusu i metadanych pod kolejne laby:
   - Hybrid Search (FTS + wektory),
   - RAG (Retrieval-Augmented Generation).



## 2. Przygotowanie środowiska

### 2.1. Wymagania wstępne

Zakładamy, że masz już za sobą:

a. Lab 4 – ElasticSearch + Morfologik (full-text search),

b. Lab 5 – ElasticSearch + dense_vector (embeddingi E5 + kNN). 

Jeśli jeszcze są przed Tobą, zrób je w sugerowanej przeze mnie kolejności, plis.

Do dzisiejszego labu potrzebujesz:

- Docker / Docker Desktop,
- Python 3.10+ z bibliotekami:
  - `qdrant-client`,
  - `sentence-transformers`,
  - `torch`,
  - `requests`,
  - `tqdm`,
- ElasticSearch 8.19.x z włączonym `dense_vector`,
- uruchomioną (lokalnie lub w chmurze) instancję Qdrant,
- próbkę korpusu CulturaX-PL, oczyszczoną jak w poprzednich labach:
  - min. 2000–5000 pasaży (2–5 zdań),
  - zapisanych w pliku `data/culturax_pl_clean.jsonl`:

```json
{ "id": "1", "text": "…", "domain": "news", "date": "2023-05-01" }
{ "id": "2", "text": "…", "domain": "blog", "date": "2021-02-10" }
```



## 3. Przypomnienie: wyszukiwanie semantyczne

Klasyczne FTS (BM25) działa na słowach/lematach i ich częstości.
Wyszukiwanie semantyczne działa na embeddingach – wektorach x1,x2,…,xdx₁, x₂, …, x_dx1​,x2​,…,xd​, które opisują „znaczenie” tekstu w przestrzeni d-wymiarowej.

### 3.1. Minimalny pipeline semantyczny

1. Weź dokument (`text`).
2. Oblicz embedding z modelu (np. `intfloat/multilingual-e5-small`).
3. Zapisz go wraz z metadanymi w bazie (ES albo Qdrant).
4. Dla zapytania użytkownika:
   - generujesz embedding zapytania,
   - liczysz podobieństwo (cosinus / dot product) do wektorów dokumentów,
   - zwracasz k najbardziej podobnych dokumentów.

### 3.2. Ograniczenia wyszukiwania semantycznego

Embeddingi:

- nie widzą pisowni – „koty” vs „ko ty” → może się srogo pomylić,
- nie zawsze dobrze radzą sobie z:
  - skrótami, akronimami (`PKP`, `PAN`, `UW`),
  - numerami seryjnymi, ISBN, numerami spraw,
  - bardzo długimi dokumentami – jeden wektor „spłaszcza” wszystkie wątki,
- dla języka polskiego część informacji o fleksji jest „wtopiona” w przestrzeń, ale nie mamy tu tak precyzyjnej kontroli jak z Morfologikiem.

Dzisiejsze laboratorium ma Ci pokazać kiedy semantyka wygrywa, a kiedy przegrywa – i dlaczego potrzebujemy wyszukiwania hybrydowego.



## 4. Qdrant – baza wektorowa w praktyce

### 4.1. Podstawowe pojęcia

W Qdrant pracujesz z:

a. klastrem – instancja Qdrant (lokalnie / w chmurze),

b. kolekcją – odpowiednik „tabeli”/„indeksu”, zestaw punktów o wspólnym wymiarze wektora,

c. punktami (points) – pojedyncze dokumenty:

- `id` – unikalny identyfikator (np. UUID),
- `vector` – embedding,
- `payload` – metadane (JSON: `author`, `domain`, `date`, `section`, …).

Qdrant jest wyspecjalizowany w przybliżonym kNN (ANN) z filtracją po payloadzie.

### 4.2. Tworzenie kolekcji (koncepcyjnie)

Przykładowa kolekcja `culturax_semantic`:

- `vector_size`: 384 (dla `multilingual-e5-small`),
- `distance`: `Cosine`,
- `payload_schema`:
  - `id: keyword`,
  - `domain: keyword`,
  - `date: string` (lub `datetime`),
  - `author: keyword?`,
  - `section: keyword?`.

W Pythonie (szkic):

```
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams, FieldType, PayloadSchemaType

client = QdrantClient("localhost", port=6333)

client.recreate_collection(
    collection_name="culturax_semantic",
    vectors_config=VectorParams(size=384, distance=Distance.COSINE),
)
```

### 4.3. Zapytanie semantyczne z filtrem

1. Embedding zapytania (`query: …`).
2. Zapytanie wektorowe `search` z `limit` i `filter`:

- `filter` może zawęzić wyszukiwanie:
  - `domain = news`,
  - `date >= 2020-01-01`,
  - `author in ["Sinek", "Collins"]`.

Qdrant wypluwa listę punktów: `id`, `score`, `payload`.



## 5. ElasticSearch jako silnik wektorowy

### 5.1. Co już masz z Lab 5

- Indeks `culturax_vectors` (lub podobny) z polami:

  a. `text: text`,

  b. `domain: keyword`,

  c. `date: date`,

  d. `vector: dense_vector (384D, similarity: cosine)`.

### 5.2. Co robi ES wektorem?

- Przechowuje wektor w polu `dense_vector`.

- Buduje strukturę HNSW do przybliżonego kNN.

- W zapytaniu `_search` używasz sekcji `knn`:

  a. `field: vector`,

  b. `query_vector: [ … ]`,

  c. `k`, `num_candidates`.

ES jest „silnikiem ogólnym”, Qdrant – wyspecjalizowanym systemem do wektorów z bardzo bogatym API dla filtracji, upsertów, payloadów, itp.



## 6. Przygotowanie danych do labu

### 6.1. Korpus semantyczny

Użyj tego samego `culturax_pl_clean.jsonl`, co w Lab 5, ale dodaj (jeśli możesz):

- autora / źródło (`author` lub `source`),
- kategorie tematyczne (np. `topic`, jeśli masz),
- informację o długości (`len_chars` / `len_tokens`).

Przykładowy rekord wejściowy:

```json
{
  "id": "abc123",
  "text": "Praca z ludźmi wymaga zaufania i jasnej komunikacji...",
  "domain": "blog",
  "date": "2022-11-10",
  "author": "Jan Kowalski",
  "topic": "management"
}
```

### 6.2. Embeddingi

Użyj tego samego modelu, co w Lab 5 (np. `intfloat/multilingual-e5-small`):

- dokumenty: `passage: {text}`,
- zapytania: `query: {text}`.

Embeddingi:

- znormalizowane L2, żeby cosinus = dot product,
- wektor wrzucony do:
  - pola `vector` w ElasticSearch,
  - pola `vector` w Qdrant (`vectors` / `vector`).



## 7. Ćwiczenie 1 – Semantyka vs składnia (wielosegmentowe wyrażenia)

### 7.1. Scenariusz

Wybierz z korpusu lub wymyśl minimum 5 par wyrażeń, które:

- różnią się składnią / szykiem / segmentacją,

- a semantycznie znaczą prawie to samo.

Przykłady (możesz podmienić na swoje):

1. „praca z ludźmi” vs „współpraca z innymi ludźmi w zespole”
2. „uczenie maszynowe w medycynie” vs „zastosowania ML w diagnostyce”
3. „wpływ inflacji na wynagrodzenia” vs „jak wzrost cen zmienia płace”
4. „polska scena polityczna 2023” vs „sytuacja polityczna w Polsce po wyborach”
5. „językoznawstwo korpusowe” vs „analiza języka na korpusach tekstowych”

### 7.2. Zadanie

Dla każdej pary:

1. Wygeneruj embedding zapytania `query: …`.
2. Uruchom kNN w ElasticSearch oraz search w Qdrant:
   - `k = 10`, `num_candidates = 200` (w ES).
3. Zapisz ranking Top-10 w tabeli:

| #    | Zapytanie | Silnik | Top-3 id | Czy wyniki pasują? (Tak/Nie + komentarz) |
| ---- | --------- | ------ | -------- | ---------------------------------------- |
|      |           |        |          |                                          |

1. Sprawdź:
   - czy różne warianty zapytania prowadzą do podobnych dokumentów,
   - czy zmiana szyku („praca z ludźmi” vs „z ludźmi praca nie jest łatwa”) coś psuje,
   - czy krótkie zapytania są gorsze niż dłuższe (bardziej opisowe).

### 7.3. Wnioski, które masz zanotować

1. Jak bardzo embeddingi są wrażliwe na drobne zmiany składni?
2. Czy lepiej działają zapytania:
   - bardzo krótkie (2–3 słowa),
   - czy minimalne zdania (8–15 słów)?
3. Czy Qdrant i ES zwracają podobne wyniki, gdy zmieniasz składnię?



## 8. Ćwiczenie 2 – Fleksja polska a embeddingi

W Lab 4 Morfologik „prostował” fleksję. Teraz zobaczysz, co z tym robi model E5.

### 8.1. Przygotuj listę grup fleksyjnych

Wybierz 3–5 grup:

1. człowiek / ludzie / ludzkość / ludzkiego / ludzkimi …
2. pies / psa / psu / psami / psach …
3. nazwisko z korpusu (np. coś w stylu „Dąbrówka”: Dąbrówka, Dąbrówki, Dąbrówkę, Dąbrówką).
4. (opcjonalnie) nazwy miast, instytucji, itp.

### 8.2. Test 1 – zapytania jednowyrazowe

Dla pojedynczych form (np. `pies`, `psu`, `psami`):

1. Oblicz embedding dla `query: pies`, `query: psu`, `query: psami`.
2. Uruchom kNN (ES + Qdrant):
   - sprawdź, czy Top-5 dla tych form są do siebie podobne.
3. Zapisz w tabeli:

| Grupa | Forma | Top-3 dokumenty | Czy te same co dla innych form? |
| ----- | ----- | --------------- | ------------------------------- |
|       |       |                 |                                 |

### 8.3. Test 2 – zapytania frazowe

Zbuduj frazy:

- „ludzie pracujący w zespole”,
- „praca psa w policji”,
- „badania Dąbrówki nad semantyką”.

Porównaj:

- wyniki FTS (Lab 4, Morfologik, `match`/`match_phrase`),
- wyniki wektorowe (ES + Qdrant).

> Czy embeddingi:
>
> - „rozumieją” odmianę, ale gubią dokładne dopasowanie?
> - czy może radzą sobie całkiem dobrze bez znajomości morfologii?

### 8.4. Mini-komentarz porównawczy (do raportu)

Odpowiedz na pytanie:

> W jakich przypadkach embeddingi radzą sobie dobrze z fleksją polskiego, a w jakich
>  lepiej sięgnąć po Morfologik i FTS?





## 9. Ćwiczenie 3 – Filtry semantyczne i kontekst RAG

Zbliżamy się do RAG-a – zacznijmy myśleć o kontekście.

### 9.1. Zadanie: „Tylko Sylwia Królikowska, tylko po 2000”

1. Wybierz w korpusie autora, którego masz w metadanych (np. `author: "Sylwia Królikowska"` albo jakiś inny).
2. Napisz 3 zapytania abstrakcyjne, tylko Ty wiesz, co masz w korpusie. Gdybym pytała o teksty Sylwii Królikowskiej, która zajmuje się pracą w zespole i problemem przywództwa w pracy z ludźmi, to zapytałabym np o to:
   - „co X pisze o pracy z ludźmi?”,
   - „jak X definiuje przywództwo?”,
   - „co X sądzi o porażkach zespołu?”.
3. Dla każdego zapytania:
   - uruchom Qdrant z filtrem:
     - `author = X`,
     - `date >= 2020-01-01`,
   - uruchom ElasticSearch:
     - kNN + filtr `author` i zakres dat.
4. Zapisz, czy Top-3 różnią się między silnikami i czy faktycznie dotyczą konkretnej osoby i okresu.

### 9.2. Pytania do przemyślenia

- Co by się stało, gdybyś nie użył/a filtrów, tylko czystego wyszukiwania semantycznego?
- Jak filtracja po `author` i `date` przybliża nas do poprawnego kontekstu RAG?





## 10. Ćwiczenie 4 – Qdrant vs ElasticSearch: porównanie zachowania

### 10.1. Eksperyment

Przygotuj 10 zapytań w 3 kategoriach:

1. Parafrazy / pytania „miękkie” (tematyczne, opisowe).
2. Nazwy własne, terminy techniczne.
3. Zapytania wielosegmentowe (2–3 zdania, wielowątkowe).

Dla każdego zapytania:

1. Wygeneruj embedding `query: ...`.
2. Uruchom:
   - kNN w ElasticSearch (`k=10`, `num_candidates=400`),
   - `search` w Qdrant (`limit=10`).
3. Zbierz rezultaty w tabelę:

| Zapytanie | Typ  | ES – 3 przykłady wyników | Qdrant – 3 przykłady wyników | Komentarz (kto lepiej, czemu?) |
| --------- | ---- | ------------------------ | ---------------------------- | ------------------------------ |
|           |      |                          |                              |                                |

### 10.2. Na co zwracać uwagę

1. Czy któryś silnik:
   - lepiej radzi sobie z krótkimi hasłami?
   - lepiej z wielozdniowymi, długimi pytaniami?
2. Czy w którymś wypadku widać wpływ:
   - HNSW / `num_candidates`,
   - ograniczeń pamięciowych?



## 11. Pytania kontrolne

1. Czym różni się *full-text search* od wyszukiwania semantycznego?
2. Jakie elementy składają się na „punkt” w Qdrant?
3. Dlaczego wektory zwykle są normalizowane L2 przed zapisaniem?
4. Czym różnią się role:
   - `passage:` vs `query:` w modelach E5?
5. Dlaczego zbyt długie dokumenty (np. 5 stron tekstu w jednym wektorze) pogarszają wyniki wyszukiwania semantycznego?
6. Jakie problemy powodują:
   - akronimy (ChRL, ABW),
   - numery seryjne / ISBN / identyfikatory,
   - literówki w nazwiskach
      w kontekście wyszukiwania wektorowego?
7. Kiedy lepiej oprzeć się na architekturze FTS + Morfologik, a kiedy na embeddingach?



## 12. Zadania do raportu –  **wyszukiwanie najbardziej podobnych tekstów**

Celem zadania domowego jest zaprojektowanie sprytnego sposobu wykrywania par najbardziej podobnych tekstów w korpusie.
 Nie chodzi tylko o techniczne „policz cosinus”, ale o przemyślany eksperyment.



### 12.1. Definicja podobieństwa

1. Zaproponuj roboczą definicję „podobieństwa” dla tego korpusu. Jak to stwierdzić? Zastanów się, czy w podobieństwie chodzi o to:

   - czy chodzi o parafrazy (prawie to samo, innymi słowami)?

   - czy teksty są na ten sam temat (np. dwa artykuły o tym samym wydarzeniu)?
   - czy teksty napisano w tym samym stylu lub dotyczą tej samej domeny (np. dwie recenzje filmu)?

2. Zastanów się, czy chcesz unikać „prawie duplikatów” (copy-paste) – np. jeśli korpus był deduplikowany.

W raporcie bardzo jasno opisz: co dokładnie chcesz znaleźć, jak definiujesz podobieństwo (nie chodzi mi tu o definicję, ale o założenia, którymi się kierujesz, kiedy coś udowadniasz).



### 12.2. Strategia techniczna

1. Wybierz podzbiór korpusu:
   - min. 2000–5000 dokumentów, żeby zadanie nie było trywialne.
2. Oblicz embeddingi dla wszystkich dokumentów (jeśli jeszcze ich nie masz) i zapisz je:
   - w Qdrant (kolekcja `culturax_semantic`),
   - opcjonalnie – w pliku `vectors.npy` / `vectors.parquet` (lokalnie).
3. Zaprojektuj algorytm szukania par:

#### 

I. Opcja 1: Qudrant jako wykrywacz pokrewieństwa

Dla każdego dokumentu:

1. Wywołaj `search` w Qdrant:
   - zapytanie = jego własny wektor,
   - `limit = k` (np. 5),
   - uwaga: odfiltruj `id` samego dokumentu (`must_not` lub ignoruj pierwszy wynik).
2. Zapisz najbardziej podobny dokument wraz z wynikiem podobieństwa (`score`).

Otrzymasz listę par `(doc_i, doc_j, score_ij)`.
Uwaga: te pary są *kierunkowe* – możesz chcieć je zsymetryzować:

- dla każdej pary posortuj `(id_a, id_b)`,
- zachowaj najwyższe `score` dla danej pary.

#### 

II. Opcja 2: Lokalna macierz podobieństwa (dla mniejszego N)

Dla N ≤ 2000:

1. Zbuduj macierz `N x d` embeddingów.
2. Policz macierz podobieństwa (cosinus) – np. używając mnożenia macierzowego.
3. Wyzeruj przekątną (self-similarity).
4. Znajdź Top-K najwyższych wartości podobieństwa.

Ta opcja jest bardziej matematyczna, ale mniej skalowalna.



### 12.3. Sprytne kryteria i pułapki

Twoje wyzwanie polega na tym, żeby nie zgodzić się na pierwszy lepszy algorytm wyznaczania podobieństwa, ale:

1. ustawić sensowny próg podobieństwa, np. `cosine >= 0.8`:

   a. Ile par spełnia taki próg?

   b. Czy to nie za dużo / za mało?

2. usunąć pary „nudne” (jeśli takie występują):

   a. np. dokumenty zbyt krótkie (`len_chars < 80`),

   b. dokumenty z tego samego czasu, dotyczące tej samej domeny (prawdopodobne duplikaty serwisu).

3. zróżnicować domeny:

   a. sprawdź, czy są pary bardzo podobne, ale z różnych `domain` (np. news + blog).

4. wprowadzić ograniczenie odległości tekstowej:

   a. policz prostą metrykę: stosunek długości wspólnego n-gramu (np. trigramu) do całego tekstu,

   b. odfiltruj pary, które są prawie identyczne na poziomie ciągu znaków.

> Cel: znaleźć pary, które są semantycznie bardzo zbliżone, ale nie są IDENTYCZNE.



### 12.4. Ewaluacja jakości

1. Wybierz min. 20 par o najwyższym podobieństwie (po filtrach).
2. Oceniaj ręcznie:
   - 0 – para niepodobna (model się myli),
   - 1 – ten sam temat, ale różne szczegóły,
   - 2 – bardzo mocne podobieństwo / parafraza.
3. Policz:
   - średni score modelu dla par z oceną 2,
   - średni score modelu dla par z oceną 0–1.

Czy widać sensowny próg, powyżej którego „prawie zawsze” masz prawdziwe podobieństwa?

### 

W raporcie napisz:

1. Jak zdefiniowałeś/aś podobieństwo w tym zadaniu?
2. Jaką strategię techniczną wybrałeś/aś (Qdrant vs lokalna macierz)?
3. Jakie filtry zastosowałeś/aś, żeby uniknąć błahych podobieństw / zduplikowanych par?
4. Pokaż 5–10 najciekawszych par:
   - takie, których nie podejrzewałeś/aś, a okazały się bardzo podobne,
   - takie, gdzie model się spektakularnie pomylił.
5. Jakie wnioski można wyciągnąć dla:
   - budowy RAGa (np. łączenie parafraz, klastrów tematycznych),
   - ewentualnej budowy korpusu, clusteringu / deduplikacji istniejącego korpusu?



## 13. Miejsca do zajrzenia

1. Dokumentacja Qdrant (API, filtrowanie, kolekcje).
2. Dokumentacja ElasticSearch – dział o `dense_vector` i kNN (jeśli nie zrobiłeś/aś tego przy labie 5).
3. Opis modeli E5 – jak korzystać z prefiksów `query:` / `passage:`.