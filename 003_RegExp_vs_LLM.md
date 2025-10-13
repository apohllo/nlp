# Laboratorium 3: RegExp vs LLM  
### Ekstrakcja informacji, polska fleksja, daty i rachunki bankowe

---

## Źródło danych

**Korpus:** [Hugging Face – oscar-corpus/OSCAR-2301](https://huggingface.co/datasets/oscar-corpus/OSCAR-2301)  

**Split:** `pl`  

**Licencja:** MIT-like / CC (sprawdź kartę datasetu).

OSCAR to surowy web-crawl z polskiego internetu.  

Zawiera spam, HTML i treści obcojęzyczne.  

Każdy i każda z Was ma obowiązek samodzielnie oczyścić dane – to element oceny laboratorium.



**Cele laboratorium**

1. Zaimplementowanie wyrażeń regularnych (RegExp) do wyszukiwania w języku polskim struktur takich jak:  
   - daty (numeryczne i słowne),  

   - godziny,  
   - kwoty PLN,  
   - e-maile, telefony, URLe,  
   - numery kont bankowych (IBAN/NRB),  
   - formy fleksyjne na przykładzie „człowiek” / „ludzie”.  

2. Zbudowanie promptów LLM (Ollama / LM Studio) wykonujących te same zadania.  

3. Porównanie skuteczności i czasu pracy RegExp vs LLM.  

4. Przygotowanie raportu i propozycji rozwiązania hybrydowego.



## 1. Przygotowanie środowiska

### Instalacje
```bash
pip install datasets regex pandas matplotlib rapidfuzz
pip install langdetect
```

co robi każda z tych bibliotek i dlaczego są potrzebne w laboratorium:

`datasets` -- umożliwia łatwe pobieranie i przetwarzanie dużych zbiorów danych (datasetów) w języku Python z `HuggingDace`.

Użycie w laboratorium:

- wczytanie korpusu OSCAR-PL (`load_dataset("oscar-corpus/OSCAR-2301", "pl")`),
- filtrowanie, losowanie i iteracja po tekstach,
- eksport danych po czyszczeniu.

Używanie `datasets` to standardowy sposób pracy z otwartymi korpusami językowymi.



`regex `-- ulepszony moduł Pythona dla wyrażeń regularnych (`re`), pozwala na bardziej zaawansowane dopasowania niż wbudowany `re`, np.:

- pełna obsługa Unicode (ważna dla polskich znaków),

- możliwość tzw. overlapping matches,
- wsparcie dla nazwanych grup i rekurencji.

Użycie w laboratorium: dopasowywanie dat, IBAN-ów, miesięcy, form fleksyjnych itp.

W kontekście polskiego tekstu `regex` jest dokładniejszy niż `re`.



`pandas` -- operacje tabelaryczne, przetwarzanie wyników, tworzenie raportów. Umożliwia prostą analizę ilościową wyników ekstrakcji.

Użycie w laboratorium:

- przechowywanie wyników ekstrakcji,
- liczenie metryk Precision/Recall/F1,
- generowanie tabel porównawczych RegExp vs LLM.



`rapidfuzz` -- biblioteka podobna do `fuzzywuzzy`, ale znacznie szybsza. Dopasowuje teksty przy niewielkich różnicach (np. literówki, brak spacji). Pomaga w precyzyjniejszej ocenie trafności ekstrakcji.

Użycie w laboratorium:

- ocena dopasowań RegExp i LLM z tolerancją na błędy,
- np. „wrzesien” vs „wrzesień”, „PL441090…” vs „PL 44 1090 …”.



## 2. Korpus OSCAR-PL

### 2.1. Pobranie i próbka

```
from datasets import load_dataset
ds = load_dataset("oscar-corpus/OSCAR-2301", "pl", split="train")
ds_small = ds.shuffle(seed=42).select(range(50_000))
```

Zawsze warto próbkować pobrany korpus, żeby lepiej dostosować warsztat do pracy z danymi. Kiedy zobaczymy fragment Oscara, dojdziemy do wniosku, że dane wymagają oczyszczenia.



### 2.2. Czyszczenie

OSCAR to dane z sieci i jako takie dane te wymagają filtracji. Czyszczenie danych to indywidualna kwestia zależąca od wnikliwego wglądu w dane, spostrzegawczości, determinacji i wychwycenia wzorców, dlatego będzie podlegała ona ocenie. Opisz w sprawozdaniu, jak czyściłeś / czyściłaś dane i dlaczego ten sposób jest Twoim zdaniem najlepszy.



## 3. RegExp — ekstrakcja wzorców

### 3.1. Daty i godziny

Wzorce dla dat i godzin:

```bash
# miejsce na Twój kod
```



### 3.2. Daty słowne i miesiące

Wzorce dla dat napisanych w możliwie wielu formatach

```
# miejsce na Twój kod
```



### 3.3. E-mail, telefon, URL

Wzorce dla maili, numerów telefonów i linków napisanych w możliwie wielu formatach

```
# miejsce na Twój kod
```



### 3.4. Kwoty PLN

Kwoty podawane w złotówkach

```
# miejsce na Twój kod
```



### 3.5. Konto bankowe (IBAN / NRB)

Wzorce dla numerów kont bankowych napisanych w możliwie wielu formatach

```
# miejsce na Twój kod
```



### 3.6. Fleksja „człowiek/ludzie”

Wzorce dla form fleksyjnych rzeczownika człowiek

```
# miejsce na Twój kod
```



## 4. LLM — ekstrakcja tymi samymi kategoriami

### Przykład prompta dla wyszukiwania daty 

(UWAGA: prompt jest niepełny i nie zawiera wskazania na zawiłości fleksyjne języka polskiego.)

```
Jesteś ekstraktorem wzorców.  
Zwracasz TYLKO JSON {"matches":[...]}.
Wypisz wszystkie daty (YYYY-MM-DD, D.M.YYYY, D miesiąc [YYYY]).
Tekst:
"""
{{TEKST}}
"""
Jeśli brak, zwróć {"matches":[]}.
```



## 5. Ewaluacja

### 5.1. Złoty standard

Oznacz ręcznie prawidłowe dopasowania (min. 500–1000 zdań, co najmniej 2 kategorie) z wyczyszczonego zbioru.

UWAGA: czyszczenie nie polega na usuwaniu czegokolwiek, istotne informacje w tekstach nadal powinny zostać.

### 5.2. Metryki

```
def prf1(gold, pred):
    G, P = set(gold), set(pred)
    tp = len(G & P)
    prec = tp / len(P) if P else 0
    rec  = tp / len(G) if G else 0
    f1   = 2 * prec * rec / (prec + rec) if (prec + rec) else 0
    return prec, rec, f1
```

### 5.3. Tabela wyników

Przykładowa prezentacja wyników może wyglądać następująco:

| Kategoria   | Metoda | Precision | Recall | F1   | Czas [s] |
| ----------- | ------ | --------- | ------ | ---- | -------- |
| Daty słowne | RegExp |           |        |      |          |
| Daty słowne | LLM    |           |        |      |          |
| IBAN        | RegExp |           |        |      |          |
| IBAN        | LLM    |           |        |      |          |
| Człowiek    | RegExp |           |        |      |          |
| Człowiek    | LLM    |           |        |      |          |

------

## 6. Wizualizacje

- Histogram godzin (HH:MM → HH)
- Histogram miesięcy (marzec/marca → marzec)
- Porównanie liczby trafień poprawnych: RegExp vs LLM
- Opcjonalnie wykres błędów (false positive/false negative)

------

## 7. Raport do oddania

### Zawartość sprawozdania

- Wzorce RegExp z krótkim komentarzem i przykładami trafień/błędów.
- Prompty użyte dla obu modeli, przykładowe odpowiedzi (fragmenty + zrzuty ekranu/CLI).
- Tabela wyników (dla min. 2 kategorii).

Wnioski: co działa lepiej i kiedy? Jakie wzorce są „łatwe” / „trudne” dla LLM vs RegExp?

------

## 8. Pytania o umiejętności modeli

Odpowiedz zwięźle (1–4 zdania na punkt) na poniższe pytania. Wnioski sformułuj na podstawie swoich testów:

1. Polskie znaki i fleksja: czy modele poprawnie rozpoznają słowa z diakrytykami? czy mylą formy?
2. Deterministyczność: jak `temperature` wpływa na stabilność listy dopasowań? czy `temperature=0` eliminuje różnice?
3. Precyzja vs. uogólnienie: kiedy LLM uogólnia zbyt mocno (FP), a kiedy RegExp gubi rzadkie przypadki (FN)?
4. Odporność na szum: literówki w e-mailach/linkach — kto radzi sobie lepiej i dlaczego?
5. Skalowanie z długością: jak długość kontekstu wpływa na trafność narzędzi? Czy dzielenie na akapity pomaga?
6. Formatowanie wyjścia: jak często model zwraca niepoprawny JSON? co pomaga (instrukcje, kilka przykładów)?
7. Transfer między kategoriami: czy prompt do dat łatwo przerobić na inny IBAN → telefony/kwoty? czy model myli się między kategoriami?
8. Bielik vs Llama/Gemma/inny model: różnice jakościowe (i prędkościowe) w Twoim środowisku.

**Podsumowanie:**

 Kiedy wybrał(a)byś RegExp, a kiedy LLM?
 Jak można połączyć oba podejścia (np. RegExp do walidacji wyników modelu)? Zaproponuj rozwiązanie.