# Regular expressions (aka regex)

The task is concentrated on using regular expressions for extracting basic information from textual data. 
You will get more familiar with the regexp features that are particularly important for natural language processing applications.

## Task

A FIQA-PL dataset containing Polish questions and answers is available at [Huggigface](https://huggingface.co/datasets/clarin-knext/fiqa-pl).
In this lab we only concentrate on the `corpus` split of the dataset.

Task objectives (8 points):

1. Devise two regular expressions:
   * extracting times, e.g. recognizing `20:30` as an instance of a time.
   * extracting dates, e.g. recognizing `20 września` as an instance of date.
2. Search for occurrences of times and dates in the dataset.
3. Plot results from point 2:
   * for times create a bar plot for full hours.
   * for dates create a bar plot for months.
4. Compute the number of occurrences of `styczeń` word in any inflectional form. Use a compact form for the query (i.e. joining all forms of the word by alternative is forbidden).
5. As in 4, but preceded by a number and a space.
6. As in 4, but not preceded by a number and a space. Check if the results from 5 and 6 sum to 4.


Answer the following questions (2 points):
1. Are regular expressions good at capturing times?
2. Are regular expressions good at capturing dates?
3. How one can be sure that the expression has matched all and only the correct expressions of a given type?

## Hints

* Some programming languages allow to use Unicode classes in regular expressions, e.g.
  * `\p{L}` - letters from any alphabet (e.g. a, ą, ć, ü, カ)
  * `\p{Ll}` - small letters from any alphabet
  * `\p{Lu}` - capital letters from any alphabet
* Not all regular expressions engines support Unicode classes, e.g. `re` from Python does not.
  Yet you can use `regex` library (`pip install regex`), which has much more features.
* Regular expressions can include positive and negative lookahead and lookbehind constructions, e.g.
  * *positive lookahead* - `(\w+)(?= has a cat)` will match in the string `Ann has a cat`, but it will match `Ann` only.
  * *negative lookbehind* - `(?<!New )(York)`, will match `York` in `Yorkshire` but not in `New York`.
* `\b` matches a word border. Regexp `fish` will match in `jellyfish`, but `\bfish\b` will only match `fish`.
  In the case of Python you should use either `'\\bfish\\b'` or `r'\bfish\b'`.
* `\b` is dependent on what is understood by "word". For instance in Ruby polish diacritics are not treated as parts of
  a word, thus `\bpsu\b` will match both `psu` and `psuć`, since `ć` is a non-word character in Ruby.
* Some languages, e.g. Ruby, support regexp match operator as well as regexp literals (`=~`, /fish/ respectively 
  in the case of Ruby and Perl). Notably Python does not support either.
* You should be very careful when copying regexps from Internet - different languages and even different versions of the
  same language may interpret them differently, so make sure to always test them on a large set of diversified examples.
* You can try regexes using https://regex101.com. It allows you to compare the matches between different programming languages.
* You can use `datasets` Python library, to facilitate downloading and loading of the `clarin-knext/fiqa-pl` dataset.
