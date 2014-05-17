module Test::Corpus:auth<github:flussence>:ver<1.2.0>;

use Test;

#= Convenience sub for testing filter functions of arity 1
sub simple-test(&func) is export {
    return sub (IO::Handle $in, IO::Handle $out, Str $testcase) {
        is &func($in.slurp), $out.slurp, $testcase;
    }
}

#= Runs tests on a callback. The callback gets passed input/output filehandles,
#  and the basename of the test file being run. Tests are run in no particular
#  order.
sub run-tests(
    &test,
    Int  :$tests-per-block  = 1,
    Str  :$basename         = $*PROGRAM_NAME.path.basename,
    Bool :$force-threaded   = %*ENV<TEST_CORPUS_THREADED>.Bool
) is export {
    my @files = dir('t_files/' ~ $basename ~ '.input');

    if $tests-per-block > 1 {
        warn '$tests-per-block is deprecated; please use 1 subtest per block';
    }

    plan @files * $tests-per-block;

    my &runner = &single-test.assuming(&test);

    # Threaded currently doesn't work, and will give you horrible segfaults if
    # you try to use it.
    sink $force-threaded
            ?? await @files».&runner».&start
            !! @files».&runner».();
}

my sub single-test(&test, $input) returns Callable {
    return &test.assuming(
        open($input),
        open($input.subst('.input/', '.output/')),
        $input.basename
    );
}

# vim: set tw=80 :
