# Laboratorium 1: Start z lokalnym LLM (Ollama lub LM Studio)

**Cel zajęć**

- Instalacja i uruchomienie lokalnego dużego modelu językowego przy pomocy narzędzi **Ollama** *i / lub* **LM Studio**.
- Pobranie co najmniej dwóch modeli i ich porównanie, uruchomienie prostych zapytań sprawdzających wiedzę i możliwości każdego modelu i weryfikacja działania modelu na języku polskim.
- Porównanie wydajności CPU vs GPU (jeśli dostępna) oraz obserwacja działania modeli uwarunkowanego dostępną infrastrukturą oraz własnościami modelu.

---
## 1. Wymagania wstępne

- Komputer z **Windows / macOS / Linux**.
- ~**8–16 GB RAM** (więcej = lepiej), miejsce na dysku (min. 4–10 GB na modele).
- (Opcjonalnie) **GPU** z obsługą akceleracji (Metal na macOS, CUDA na Windows/Linux, ROCm na wybranych Radeonach).
- Dostęp do Internetu do pobrania modeli.

> **Uwaga**: Modele lokalne działają offline po pobraniu, ale pierwsze uruchomienie wymaga pobrania plików wag.

---
## 2. Instalacja — wybierz jedną ścieżkę

### 2a. Ollama

1. **Instalator**:
   - **macOS**: pobierz instalator z oficjalnej strony i zainstaluj jak zwykłą aplikację.
   - **Linux**: w terminalu (bash):
     ```bash
     curl -fsSL https://ollama.com/install.sh | sh
     ```
   - **Windows 10/11**: pobierz instalator `.exe` i uruchom (po instalacji dostępna będzie aplikacja „Ollama” oraz usługa w tle).

2. **Weryfikacja instalacji**:

   ```bash
   ollama --version
   ollama list
   ```
   Jeśli polecenie `ollama` nie jest widoczne, zrestartuj terminal/komputer. 

   Uwaga dla Windowsa: `ollama` świetnie działa przez PowerShell.

3. **Modele dostępne w ramach usługi**

   Platforma www.ollama.com zapewnia możliwość skorzystania z dużej liczby modeli o zróżnicowanych parametrach. Żeby przeglądać modele, należy wejść w odpowiednią zakładkę (`Models`) i zapoznać się z właściwościami każdego modelu. Najlepiej zrobić to zanim zdecydujemy się na pobranie konkretnego modelu.

4. **Pobranie modelu (przykłady)**:

   ```bash
   # mały i szybki model do testów
   ollama pull qwen2.5:1.5b
   ollama pull gemma2:2b
   ollama pull SpeakLeash/bielik-1.5b-v3.0-instruct:Q8_0
   
   # średni i bardziej kompetentny model
   ollama pull llama3.1:8b
   ollama pull SpeakLeash/bielik-7b-instruct-v0.1-gguf:Q8_0
   ollama pull SpeakLeash/bielik-11b-v2.3-instruct:Q8_0
   ```

5. **Pierwsze uruchomienie**:

   ```bash ollama run llama3.1:8b
   ollama --help
   ```

   wyświetla możliwe interakcje z `ollamą`. Kiedy już zaciągnęliśmy model, powinniśmy móc uruchomić go poleceniem:

   ```bash
   ollama run llama3.1:8b
   ```
   Uwaga: nazwa modelu (i dodatkowe tagi jak w przypadku `SpeakLeash/bielik-7b-instruct-v0.1-gguf:Q8_0` muszą się zgadzać co do litery).

   Następnie wpiszmy w REPL-u pytanie lub polecenie, żeby móc sprawdzić, czy model działa np.: `Napisz haiku po polsku o jesieni.`

6. **Użycie z linii poleceń (jednorazowa odpowiedź)**:
   ```bash
   echo "Przedstaw w 3 punktach czym jest uczenie maszynowe" | ollama run SpeakLeash/bielik-11b-v2.3-instruct:Q8_0
   ```

   Uwaga: żeby przetestować to polecenie, trzeba upewnić się, że komenda `run` uruchomiona będzie na modelu, który pobraliśmy.

7. **Sprawdzenie GPU / zasobów**: podczas generowania odpowiedzi sprawdź obciążenie GPU/CPU (Monitor aktywności / Menedżer zadań / `nvidia-smi`).

> **Tip**: `OLLAMA_NUM_GPU=0` lub `ollama run --num-gpu 0 ...` wymusza CPU; na macOS akceleracja Metal włącza się automatycznie.

---
### 2.B. LM Studio

1. **Instalacja**: pobierz aplikację **LM Studio** (Windows/macOS/Linux) i zainstaluj.
2. **Pobranie modelu**: w zakładce **Models** wyszukaj np. `Llama 3.1 8B Instruct` lub `Qwen2.5 1.5B`, wybierz wariant **GGUF**  (np. `SpeakLeash/bielik-11b-v2.3-instruct:Q8_0`) i pobierz (jeśli nie zrobiłaś/eś tego wcześniej).
3. **Uruchom**: kliknij **Chat** → wybierz model → wpisz zapytanie testowe.
4. **(Opcjonalnie) Lokalny serwer**: zakładka **Server** → **Start Server**. Umożliwia to wywołania zewnętrzne (HTTP/OpenAI‑compatible API). Zachowaj nazwę portu.
5. **Monitor zasobów**: w aplikacji widać zużycie RAM/VRAM; dodatkowo możesz użyć systemowych narzędzi.

---
## 3. Testy funkcjonalne (PL i EN)

Wykonaj krótkie testy sprawdzające podstawowe zdolności modeli. **W każdym kroku podaj prompt, odpowiedź modelu i własne uwagi**.

1. **Wiedza ogólna**: „Kto jest autorem *Lalki*? Podaj dwuzdaniowe streszczenie.”  
2. **Instrukcje**: „Wyjaśnij jak działają listy w Pythonie i podaj dwa przykłady.”  
3. **Kreatywność**: „Napisz czterowersowy wiersz po polsku o krakowskim Smoku Wawelskim.”  
4. **Tłumaczenie**: „Przetłumacz na angielski: *Zawsze noś parasol jesienią w Warszawie.*”  
5. **Ekstrakcja informacji**: „Z tekstu: ‘Jan kupił 3 jabłka w cenie 2 zł za sztukę’ wyodrębnij: {liczba, produkt, cena_jednostkowa, waluta}  i zapisz wynik ekstrakcji w formacie JSON.”  
6. **Krótka analiza sentymentu**: „Zdanie: ‘Ten telefon jest zaskakująco dobry jak na swoją cenę’ — pozytywny / negatywny / neutralny i dlaczego?”

> **Przykłady testowe są tylko na potrzeby zajęć, każda i każdy z was powinien wymyślić własny przykład, który weryfikuje**: poprawność, halucynacje, płynność odpowiadania modelu w języku polskim, długość / strukturę odpowiedzi, szybkość generowania (tokeny, subiektywne odczucie). W tym zadaniu chodzi również o porównanie, a więc o zestawienie odpowiedzi na pytania dla dwóch modeli -- polskiego (Bielik) i trenowanego na innym języku (np. Gemma / Llama). To zadanie powinno być wykonane na początku na jak najmniejszych modelach. To samo zadanie wykonane będzie w kolejnej części na większych modelach

---
## 4. Porównanie modeli i ustawień

1. **Mały vs średni model**: uruchom te same prompty na większym modelu (jeśli ograniczają Cię zasoby komputera, możesz użyć modelu podobnej wielkości, dobrze byłoby jednak, gdyby to był model PL i Gemma / Llama. Zapisz różnice jakości / szybkości.
2. **CPU vs GPU**: jeśli masz GPU, porównaj czasy odpowiedzi (subiektywnie wystarczy) przy wymuszeniu CPU.
3. **Temperature / max tokens**: przetestuj `--temperature` (Ollama: `ollama run model -p "..." -t <temp>`) i `--num-predict` (limit długości). Opisz wpływ na odpowiedzi.

---
## 5. (Opcjonalnie) Wywołania z programów

### 5.A. Python + Ollama (CLI)
```bash
pip install ollama  # klient Python (opcjonalny)
```
```python
import subprocess, json
prompt = "Wypisz 3 zalety uczenia przez wzmacnianie, każdą zaletę umieść w jednym zdaniu."
cmd = ["ollama", "run", "llama3.1:8b"]
res = subprocess.run(cmd, input=prompt.encode(), stdout=subprocess.PIPE)
print(res.stdout.decode())
```

### 5.B. HTTP (LM Studio Server / Ollama API)
- Po uruchomieniu serwera lokalnego: wyślij żądanie `POST /v1/chat/completions` (API zgodne z OpenAI).
- Zanotuj adres (np. `http://localhost:1234/v1/chat/completions`).

---
## 6. Sprawozdanie

1. **Informacje o środowisku**: system, CPU, RAM, GPU/VRAM, wersja narzędzia, nazwy/rozmiary modeli.
2. **Polecenia uruchamiające wybrane narzędzie i wykonujące wybrane zapytania**: z pierwszego uruchomienia i z co najmniej 3 testów z sekcji 3.
3. **Tabela porównawcza**: (model × ustawienia (temperatura) × obserwacje). Krótkie wnioski.
4. **(Opcjonalnie)** plik/fragment kodu z integracji programistycznej.

---
## 7. Pytania o umiejętności modelu

Odpowiedz zwięźle (1–4 zdania na punkt), bazując na swoich testach. Jeśli nie możesz czegoś zweryfikować — zaznacz to.

1. **Język polski**: Jak oceniasz płynność, gramatykę i zasób słownictwa modelu po polsku? Jak radzi sobie z odmianą i fleksją?
2. **Faktyczność**: W jakich sytuacjach model halucynował? Jak ograniczać halucynacje (np. styl promptu, ograniczenia, RAG)?
3. **Instrukcje**: Czy model dobrze podąża za instrukcjami krok‑po‑kroku? Co pomaga (np. numerowane listy, format JSON, rola systemowa)?
4. **Rozumowanie**: Czy dostrzegasz myślenie wieloetapowe? Jakimi pytaniami to weryfikowałeś/aś? Jak wpływa to na poprawność odpowiedzi?
5. **Ekstrakcja informacji**: Jak dobrze model tworzy ustrukturyzowane wyniki (JSON, YAML, tabela)? Jakie są typowe błędy?
6. **Kreatywność vs precyzja**: Jak *temperature* wpływa na styl i dokładność? Gdzie jest rozsądny kompromis dla Ciebie?
7. **Wydajność**: Czy GPU przyspieszyło generację? Jak rozmiar modelu wpływał na czas i jakość?
8. **Bezpieczeństwo**: Czy zaobserwowałeś/aś odmawianie odpowiedzi lub cenzurę? Czy można świadomie kierować bezpieczeństwem odpowiedzi?
9. **Porównanie narzędzi** (jeśli doszło do porównania): Co wolisz — Ollama czy LM Studio? Dlaczego? Jakie są zalety/wady w Twoim środowisku?

> **I ostatnia‑refleksja (2–4 zdania)**: Czego nauczyłeś/aś się o lokalnych modelach? Co planujesz sprawdzić w kolejnych labach?

---
## Dodatkowe wskazówki

- Zacznij od **mniejszych modeli** (1–3B), potem przejdź do 7–8B i większych.
- Jeśli brakuje VRAM, użyj **wariantów skwantyzowanych (GGUF)** i mniejszych rozmiarów (np. Q4_K_M).
- Pamiętaj o **limitach kontekstu**: dłuższe wejścia mogą zostać ucięte.
- W sprawozdaniu jasno odróżniaj **obserwacje** od **przypuszczeń**.

