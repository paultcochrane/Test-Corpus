# Test::Corpus

This is a simple module that automagically iterates over input/output files and calls a callback on
each pair. Its main use is for testing filter functions produce expected output.

## Example:

    # file lib/Foo.pm:
    module Foo;
    sub rot13 is export { return $^a.trans('a'..'z' => ['n'..'z', 'a'..'m']); }

    # file test.t:
    use Test::Corpus;
    use Test;
    use Foo;
    run-tests(simple-test(&rot13));

    # directory structure (assuming default settings):
    ./
        lib/
            Foo.pm
        t/
            test.t
        t_files/
            test.t.input/
                1.txt
                2.txt
                ...
            test.t.output/
                1.txt
                2.txt
                ...
