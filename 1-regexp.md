# Regular expressions (aka regexps)

The task is concentrated on using regular expressions for extracting basic information from textual data. 
You will get more familiar with the regexp features that are particularly important in natural language processing.

## Task

A dataset containing texts of Polish statutory law is available at [http://apohllo.pl/text/ustawy.tar.gz](http://apohllo.pl/text/ustawy.tar.gz).

It contains texts of Polish bills, e.g.:

```
Tekst ustawy przyjęty przez Senat bez poprawek
 
USTAWA
z
dnia 8 listopada 2013 r.
 
o
zmianie niektórych ustaw w związku z realizacją ustawy budżetowej[1])
 
Art.
1. 
W
ustawie z dnia 4 marca 1994 r. o zakładowym funduszu świadczeń socjalnych (Dz. U.
z 2012 r. poz. 592, z późn. zm.[2]))
po art. 5b dodaje się art. 5c w brzmieniu:
„Art. 5c. W 2014 r. przez
przeciętne wynagrodzenie miesięczne w gospodarce narodowej, o którym mowa w art.
5 ust. 2, należy rozumieć przeciętne wynagrodzenie miesięczne w gospodarce narodowej
w drugim półroczu 2010 r. ogłoszone przez Prezesa Głównego Urzędu Statystycznego
na podstawie art. 5 ust. 7.”.
```

Task objectives:

1. For each bill compute the number of the following amendments present in the bill:
   * addition of a unit (e.g. **dodaje się ust. 5a**),
   * removal of a unit (e.g. **w art. 10 ust. 1 pkt 8 skreśla się**),
   * change of a unit (e.g. **art. 5 otrzymuje brzmienie**).
1. Note that other types of changes, e.g. **po wyrazach "na dofinansowanie" dodaje się wyrazy " , z zastrzeżeniem art. 21a,"**, must not be included in the result.
1. Plot results from point 1 showing how the percentage of amendments of a given type changed in the consecutive years.
1. Compute the total number of occurrences of the word **ustawa** in any inflectional form (*ustawa*, *ustawie*, *ustawę*, etc.)
   and all spelling forms (*ustawa*, *Ustawa*, *USTAWA*), excluding other words with the same prefix (e.g. *ustawić*).
1. Compute the total number of occurrences of the same word (same conditions), followed by **z dnia** expression.
1. As above, but **not** followed by **z dnia** expression. Is the result correct (result 4 =? result 5 + result 6)?
1. Compute the total number of occurrences of the word **ustawa** in any inflectional form, excluding occurrences
   following **o zmianie** expression.
1. Plot results 4-7 using a bar chart.

## Hints

* Some programming languages allow to use Unicode classes in regular expressions, e.g.
  * `\p{L}` - letters from any alphabet (e.g. a, ą, ć, ü, カ)
  * `\p{Ll}` - small letters from any alphabet
  * `\p{Lu}` - capital letters from any alphabet
* Not all regular expressions engines support Unicode classes, e.g. `re` from Python does not.
  Yet you can use `regex` library (`pip install regex`), which has much more features.
* Regular expressions can include positive and negative lookahead and lookbehind constructions, e.g.
  * *positive lookahead* - `(\w+)(?= has a cat)` will match string `Ann has a cat`, but it will match `Ann` only.
  * *negative lookbehind* - `(?<!New )(York)`, will match `Yorkshire` but not `New York`.
* `\b` matches a word boarder. Regexp `fish` will match `jellyfish`, but `\bfish\b` will only match `fish`.
  In the case of Python you should use either `'\\bfish\\b'` or `r'\bfish\b'`.
* `\b` is dependent on what is understood by "word". For instance in Ruby polish diacritics are not treated as parts of
  a word, thus `\bpsu\b` will match both `psu` and `psuć`, since `ć` is a non-word letter in Ruby.
* Some languages, e.g. Ruby, support regexp match operator as well as regexp literals (`=~`, /fish/ respectively 
  in the case of Ruby and Perl). Notably Python does not support either.
* You should be very careful when copying regexps from Internet - different languages and even different versions of the
  same language may interpret them differently, so make sure to always test them on a large set of diversified examples.
