# Laboratorium 10: Od narzędzi do Inteligentnego RAG-a



## 1. Cel zajęć

1. Zrozumienie roli ekstrakcji encji i dat w systemach wyszukiwania i RAG .

2. Łączenie wszystkich metod NLP w jedną spójną architekturę (RegExp, FTS, wektory, hybryda, RAG, reasoning)  

3. Projektowanie algorytmów self-improving retrieval z wykorzystaniem metadanych (entities, dates).

4. Konstruowanie zapytań pomocniczych (self-querying, query rewriting, clarification).

5. Implementowanie ekstrakcji encji nazwanych z użyciem konkretnego modelu NER.  

6. Implementowanie ekstrakcji dat (RegExp + NER + LLM) i budowanie pól typu `year`, `date_range` . 

7. Ewaluacja jakości kontekstu, odpowiedzi i wnioskowania.  

8. Tworzenie warstwy walidującej odpowiedzi i cytaty (prompt verification).  

9. Projektowanie benchmarków do ewaluacji RAG-a (w tym na poziomie encji i dat).

10. Konstruowanie prototypu agenta informacyjnego opartego na RAG i metadanych semantycznych  



## 2. Podsumowanie dotychczasowych

| Lab  | Temat                    | Narzędzia                           | Kompetencja                              |
| ---- | ------------------------ | ----------------------------------- | ---------------------------------------- |
| 1    | Lokalny LLM              | Ollama / LM Studio                  | uruchamianie modeli                      |
| 2    | Promptowanie             | LLM                                 | sterowanie zachowaniem systemu           |
| 3    | RegExp vs LLM            | regex, LLM                          | ekstrakcja struktur z języka naturalnego |
| 4    | ElasticSearch FTS        | BM25 + Morfologik                   | wyszukiwanie po wzorcu                   |
| 5    | Wektory w ES             | dense_vector                        | similarity search                        |
| 6    | Wyszukiwanie semantyczne | Qdrant + E5                         | wyszukiwanie wg podobieństwa             |
| 7    | Wyszukiwanie hybrydowe   | ES + Qdrant + RRF                   | połączenie metod wyszukiwania            |
| 8    | Prosty RAG               | retrieval + chunking                | pipeline RAG                             |
| 9    | Inteligentny RAG         | decomposition, memory, verification | agentowy RAG                             |
| 10   | Master AI Lab            | pełne NLP + NER + daty + RAG        | integracja całego stacku                 |



## 3. Dane do pracy

Używamy tego samego korpus, co wcześniej:

```text
data/culturax_pl_clean.jsonl
Przykładowy rekord:

json
Skopiuj kod
{
  "id": "abc123",
  "text": "Praca z ludźmi wymaga zaufania i jasnej komunikacji...",
  "domain": "blog",
  "date": "2022-11-10",
  "author": "Jan Kowalski",
  "topic": "liderzy"
}
```



Założenia:

- istnieją embeddingi (passage: dla dokumentów, query: dla zapytań),

- istnieją indeksy:

- ElasticSearch (FTS + dense_vector),
- Qdrant (embedding + payload),

- korpus jest ten sam we wszystkich narzędziach (spójne id).



### 4. Etap 1 — Ekstrakcja encji nazwanych (NER) i dat

#### 4.1. Model / narzędzie do NER
Wybierz jedno z poniższych (lub inne, ale uzasadnij):

- spaCy – model pl_core_news_lg (Polish large model z NER),

- model HuggingFace, np. dkleczek/bert-base-polish-cased-ner,

- inny polski model NER, jeżeli masz dostęp (ewentualnie https://huggingface.co/Babelscape/wikineural-multilingual-ner).

#### Przykładowy pipeline (HuggingFace, Python):

```
from transformers import AutoTokenizer, AutoModelForTokenClassification
from transformers import pipeline
```

```
model_name = "dkleczek/bert-base-polish-cased-ner"
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoModelForTokenClassification.from_pretrained(model_name)
ner = pipeline("token-classification", model=model, tokenizer=tokenizer, aggregation_strategy="simple")

text = "W 2020 roku Sylwia Królikowska prowadziła warsztaty w Warszawie."
entities = ner(text)
print(entities)
```

Implementacja zależy od wyboru narzędzia do ekstrakcji encji.

Zadania:

- przetestowanie modelu na 20–30 losowych fragmentach z korpusu,

- zapisanie wniosków:

​	a) jakie typy encji są rozpoznawane (PERSON, ORG, LOC, MISC, itp.),

​	b) jakie są typowe błędy (np. imię jako ORG, miasto jako inny typ),

​	c) jak model radzi sobie z fleksją i odmianą nazw własnych.



#### 4.2. Ekstrakcja dat – trzy podejścia
Masz zastosować trzy różne strategie:

1. RegExp + proste zasady:

daty typu 2022-11-10, 10.11.2022, 2022, w 2020 roku, itp.,

zaproponuj kilka wzorców RegExp dla polskich formatów.

2. Model NER:

sprawdź, czy model NER oznacza daty jako DATE albo inny typ,

wyciągnij wszystkie encje typu data.

3. LLM – ekstrakcja dat na podstawie promptu:

Przykładowy prompt:

```
Wyodrębnij z poniższego tekstu wszystkie daty i zakresy czasowe.
Zwróć wynik w formacie JSON:
{
  "dates": ["YYYY-MM-DD", "..."],
  "years": ["YYYY", "..."],
  "ranges": ["od YYYY do YYYY", "..."]
}
```



Twoim zadaniem jest porównanie trzech podejść i stworzenie hybrydy:

np. NER + RegExp = minimum,

LLM – tylko jako „ostatnia deska ratunku” dla nietypowych formatów.



#### 4.3. Tworzenie pól metadanych z encji i dat
Na podstawie wyników Ekstrakcji:

- dodaj pole `named_entities` (lista stringów) do payloadu / dokumentu,

- dodaj pole `years` (zredukowana lista lat z tekstu),

- opcjonalnie: `places` (wyciągnięte LOC),

użyj tego w:

- ElasticSearch:

​	a) dodatkowe pole entities typu keyword,

​	b) dodatkowe pole years typu integer lub date,

- Qdrant:

​	a) payload z listą encji i lat.

Te pola będą później wykorzystane w hybrydowym wyszukiwaniu i RAG.



## 5. NLP w praktyce

Łączenie metod na jednym korpusie

Wybierz 3 pojęcia abstrakcyjne, np.:

- "odpowiedzialność zespołowa",

- "przywództwo i liderzy",

- "zaufanie i jego utrata".

Dla każdego pojęcia:

- użyj RegExp/RegEx (Lab 3), by złapać „słowa klucze” (rdzenie, fragmenty),

- użyj BM25 w ElasticSearch (Lab 4),

- użyj wyszukiwania wektorowego (Lab 5),

- użyj Qdrant z embeddingami (Lab 6),

- użyj hybrydy (Qdrant + ES, RRF; Lab 7),

- użyj nowych pól `named_entities` i `years`:

np. filtruj po `years` >= 2018 i `named_entities` zawierających określonych autorów lub organizacje.

Stwórz tabelę porównawczą, np.:

| Temat | Metoda | Sensowność wyniku | Typowe błędy | Czy encje / daty pomogły? |
| ----- | ------ | ----------------- | ------------ | ------------------------- |
|       |        |                   |              |                           |



## 5.2 Dataset testowy (benchmark)
Na podstawie 3 pojęć:

- wybierz min. 10 dokumentów „relevant”,

- minimum 10 dokumentów „noise” (nie na temat),

zapisz jako:

```
[
  { "id": "...", "text": "...", "label": "relevant", "topic": "odpowiedzialność" },
  { "id": "...", "text": "...", "label": "noise", "topic": "odpowiedzialność" }
]
```

Dodatkowo zanotuj:

- jakie encje i lata występują w tekstach „relevant”,

- jakie typowo w „noise”.



## 6. RAG 

Tutaj używasz wszystkiego z Lab 8 i 9 + nowej warstwy NER / daty. Wybierz jeden problem badawczy, np.:

1. Jak autorzy piszą o odpowiedzialności bez użycia słowa „odpowiedzialność”?

2. Jak zmienia się sposób mówienia o przywództwie po 2020 roku?

3. Jakie miejsca (miasta, kraje) pojawiają się w kontekście kryzysów zespołowych?

Znów musisz dobrać przykłady analogicznie do danych w swoim korpusie, tak jak w laboratorium 007_Hybrid_Search.md.

Zaprezentuj pipeline (Mermaid) uwzględniający NER/daty, np.:

```
flowchart TD
    A[Zapytanie użytkownika] --> B[Decomposition]
    B --> C[Hybrid Retrieval z encjami i datami]
    C --> D[Chunking + filtr encji/daty]
    D --> E[Prompt RAG]
    E --> F[Verification: cytaty + zakres dat]
    F --> G[Memory: pytania nierozwiązane]
```

### 6.1 Zadanie – QUALITY LOOP (jakość odpowiedzi)

Wykorzystując benchmark z zadania 5, uruchom swój RAG (z encjami + datami) na min. 10 zapytaniach. Dla każdego zapytania oceń czy odpowiedź:

a) cytuje fragment tekstu,

b) zachowuje poprawny zakres czasowy (np. nie miesza 2001 i 2023 bez ostrzeżenia),

c) poprawnie rozpoznaje kluczowe osoby / organizacje.



Przykładowe przedstawienie wyników:

| Zapytanie | Label (relevant / noise) | encje | daty | halucynacje | ocena (0-2) |
| --------- | ------------------------ | ----- | ---- | ----------- | ----------- |
|           |                          |       |      |             |             |

Ocena 0-2 odpowiada systemowi oceny z laboratorium 006_Semantic_Search.md



### 6.2 Zadanie – Memory as Knowledge Accumulation

Mechanizm pamięci z Lab 9 rozszerz o informacje o encjach i datach:

```
{
  "pending_queries": [
    {
      "query": "Jak autorzy piszą o empatii po 2020 roku?",
      "entities_hint": ["empatia"],
      "years_hint": [2020, 2021, 2022, 2023],
      "attempts": 2,
      "status": "retry_later"
    }
  ]
}
```

Zaproponuj strategię:

a) jak system powinien obchodzić się z takimi pytaniami, gdy pojawią się nowe dokumenty (np. nowsze lata),

b) jak RAG mógłby „przypomnieć sobie” o starych pending queries i spróbować jeszcze raz,

c) czy powinien powiadomić użytkownika (np. w stylu „Pojawiły się nowe dane na temat X”).

### 6.3 Zadania związane z promptami dla NER i dat



Zaprojektuj co najmniej 2 prompty LLM do ekstrakcji encji:

a) prosty:

```
Wyodrębnij z tekstu wszystkie nazwane encje:
- osoby,
- organizacje,
- miejsca.

Zwróć w formacie JSON:
{
  "persons": [...],
  "organizations": [...],
  "locations": [...]
}
```



b) kontekstowy (z nastawieniem na konkretny problem, np. przywództwo):

```
Z poniższego tekstu wyodrębnij:
- osoby, które pełnią rolę liderów / przywódców,
- organizacje, w których działają,
- miejsca, jeśli są kluczowe dla kontekstu przywództwa.

Zwróć w formacie:
{
  "leaders": [...],
  "organizations": [...],
  "locations": [...]
}
```

Porównaj wyniki tych promptów z wynikami modelu NER. Zapisz, kiedy LLM jest lepszy, a kiedy gorszy od modelu.



### 6.4 Prompt dla dat w kontekście RAG

Zaprojektuj prompt, który:

- ekstraktuje daty,

- interpretuje je względem zapytania:

```
Twoim zadaniem jest:
1. Wyodrębnić wszystkie daty z poniższego tekstu.
2. Określić, czy te daty są istotne dla odpowiedzi na pytanie użytkownika.

Zwróć JSON:
{
  "dates": ["YYYY-MM-DD", ...],
  "relevant_for_question": true/false,
  "explanation": "..."
}

Pytanie użytkownika:
{QUESTION}
```

Następnie włącz tę logikę w warstwę filtracji kontekstu: jeśli fragment zawiera daty spoza interesującego zakresu, obniż jego priorytet.



### 6.5 Finalny prototyp – agent badawczy

Na koniec labu mamy w zasadzie gotowy prototyp systemu, który:

- korzysta z NER i dat do wzbogacania metadanych,

- łączy RegExp, FTS, wektory, hybrydę i RAG,

- potrafi:

  - rozkładać zapytanie na podzapytania (decomposition),

  - dynamicznie dobierać strategię retrieval (ES vs Qdrant vs hybryda),

  - weryfikować odpowiedź (cytaty + daty + encje),

  - odkładać nierozwiązane pytania i wracać do nich.



## 7. Raport końcowy

Do raportu oddaj:

- kod (modularny),

- diagram (Mermaid lub UML) obrazujący pipeline przetwarzania,

- benchmark na min. 10–15 zapytaniach,

- raport z wynikami:

  - które procedury działały najlepiej,

  - kiedy wyszukiwanie wzbogacone o NER i daty naprawdę pomogły.