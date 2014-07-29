# Test::Corpus

This is a simple module that automagically iterates over input/output files and calls a callback on
each pair. Its main use is for testing filter functions produce expected output.

See the contents of `./t/` and `./t_files/` for an example of how to use.

(2014-07-29) Note that due to a GC-related bug in MoarVM, the tests may randomly fail at 17/50. They
might also randomly work fine. Use `panda --notests install Test-Corpus` if you're affected by
that until it's resolved.

* * *

This code is released into the [Public Domain](https://creativecommons.org/publicdomain/zero/1.0/).
