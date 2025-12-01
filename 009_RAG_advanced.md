# **Laboratorium 9: RAG inteligentny: reasoning, memory, verification**



## **1. Cele laboratoriów:**

1. Rozpoznawanie typów zapytań i stosowanie dekompozycji (_decomposition_).

2. Projektowanie dynamicznego wyszukiwania (_adaptive hybrid search_).

3. Optymalizowanie jakości RAG poprzez selekcję kontekstu.

4. Rozszerzanie zapytań pomocniczych (_query rewriting_ / _clarification_).

5. Stworzenie warstwy walidującej odpowiedzi i cytaty (_prompt verification_).

6. Zaprojektowanie systemowej pamięci dla nierozwiązanych zapytań.

7. Zintegrowanie wyszukiwania, wnioskowania i zarządzania pamięcią w jedną architekturę RAGa.



## **2. Schemat systemu RAG (punkt wyjścia z Lab 8)**

```
flowchart TD
    A[Zapytanie użytkownika] --> B[Decomposition]
    B --> C[Retrieval: Qdrant]
    B --> D[Retrieval: ElasticSearch]
    C --> E[Fusion RRF]
    D --> E[Fusion RRF]
    E --> F[Chunking i selekcja]
    F --> G[Prompt RAG]
    G --> H[Odpowiedź modelu]
```

Od tego punktu zaczynamy, zabieramy się za usprawnianie logiki!

------

# **ETAP I — dynamiczny retrieval adaptacyjny**

### Zadanie 1 – analiza zapytania i zmiana wagi hybrydy

```
def choose_weights(query):
    if contains_numbers_or_acronyms(query):
        return {"es": 0.8, "qdrant": 0.2}   # factual
    else:
        return {"es": 0.4, "qdrant": 0.6}   # semantyczne
```

Przetestuj na 10 różnych zapytaniach (wykorzystaj przykłady z poprzednich labów).

### Zadanie 2 — filtrowanie retrievalu

```
def filter_retrieved(docs, min_tokens=30, max_docs=5):
    # odrzucenie dokumentów zbyt krótkich lub nietrafnych
```

Stwórz statystykę, która uwzględnia:

```
- liczba odrzuconych dokumentów  
- wpływ na jakość odpowiedzi  
```

Do czego może Ci się ona przydać?



# **ETAP II — Query Decomposition + Query Rewriting**

### Zadanie 1 – funkcja decomposition

```
def decompose_query(user_input):
    return {
      "main_question": "...",
      "sub_questions": ["...", "..."]
    }
```

Testy na zapytaniach:

| Zapytanie                               | Oczekiwane podzapytania |
| --------------------------------------- | ----------------------- |
| Jak poprawić pracę zespołową?           | 2                       |
| Jakie dane o klimacie po 2020 w Polsce? | 2                       |
| Co zawiera dokument PAN LP-78?          | factual                 |
| Co Sinek mówił o liderach?              | filtr: autor            |
| Czy inflacja rośnie?                    | factual                 |

------

## **Zadanie 2 — generowanie pytań doprecyzowujących (_clarification questions_)**

System powinien rozpoznać zapytania niejednoznaczne i doprecyzować je:

```
def generate_clarification_question(user_input):
    # LLM ma zaproponować 2-3 możliwe interpretacje
```

Przykłady zapytań:

| Wejście                        | Możliwe interpretacje                |
| ------------------------------ | ------------------------------------ |
| Co mówi PAN o kryzysie?        | PAN – instytucja / autor?            |
| Jaki ma sens odpowiedzialność? | moralna / społeczna / zawodowa?      |
| Jak zarządzać ludźmi?          | ludzki czynnik / teoria zarządzania? |

Oceń przydatność i sensowność pytań dodatkowych.



# **ETAP III — system pamięci dla nierozwiązanych pytań**

Zaimplementuj podobny kod, który działa na poniższych mechanizmach:

```
{
  "pending_queries": [
    { "id": 1, "query": "...", "status": "pending" }
  ]
}
```

Mechanizm:

- jeśli retrieval nie znalazł odpowiedzi → zapisz do pamięci
- jeśli model nie jest pewny — też odkłada pytanie
- użytkownik może potem wyświetlić listę „pytania nierozwiązane”

To fundament agenta AI.



# **ETAP IV — warstwa weryfikacji (walka z halucynacjami)**



### Zadanie 1 – funkcja walidująca cytaty

```
def validate_answer(answer, retrieved_docs):
    # czy cytat rzeczywiście występuje w retrieved_docs?
```

Jeśli `False` → odpowiedź odrzucamy. 



### Zadanie 2 – SAFE MODE

Mechanizm:

1. spróbuj ponownie z innym promptemm

2. zmień interpretację zapytania,

3. odłóż do pamięci jako nierozwiązane.

   

Przykładowa strategia:

```
{
  "retry_strategies": ["modify_prompt", "retry_retrieval", "save_to_memory"]
}
```

Jaki jest cel podobnego działania?



# **ETAP V — benchmark jakości RAG-a**

Tabela oceny jakości odpowiedzi:

| Zapytanie | Typ  | Cytuje źródło | Halucynacja | Ocena 0–2 |
| --------- | ---- | ------------- | ----------- | --------- |
|           |      |               |             |           |

Obowiązkowe testy:

- zapytania z Lab 6 (semantyka),
- zapytania z Lab 7 (hybryda),
- _decomposition_ z tego labu,
- zapytania błędne,
- zapytania spoza korpusu.

Podsumuj działanie RAGa, rozpisując je wg powyższych kryteriów.



# **ETAP VI — struktura frameworku (modularny RAG)**

Struktura repozytorium do oceny:

```
rag/
├── retrieval/
│   ├── qdrant.py
│   ├── elastic.py
│   ├── fusion.py
├── reasoning/
│   ├── chunking.py
│   ├── prompt.py
│   └── validation.py
├── memory/
│   └── pending.json
└── rag_query.py
```

Każdy moduł → minimum 1 funkcja.
 System musi działać jako całość.



# **ETAP VII — opcjonalne API (dla chętnych)**



Endpoint minimalny:

```
GET /ask?query=...
```

Endpoint rozszerzony:

```
POST /rag
{
  "query": "...",
  "mode": "safe"
}
```



# ETAP VIII — projekt końcowy (zalążek agenta AI)



# System musi zawierać:

| Funkcja             | Wymagana?          |
| ------------------- | ------------------ |
| Hybrydowy retrieval | tak                |
| Chunking            | tak                |
| Query decomposition | tak                |
| Memory              | tak                |
| Prompt verification | tak                |
| Benchmark           | tak                |
| Modularność kodu    | tak (osobne pliki) |
| API                 | opcjonalnie        |

W ramach zaliczenia proszę jak zwykle o podesłanie wyników poszczególnych kroków, zapytań w promptach i kodu. Tym razem dla czystości przewodu można kod można wysłać po prostu osobno. Nie wymagam od Was API, ale gdyby było, byłoby super, a Wy mielibyście zamknięty solidny kawałek pracy.