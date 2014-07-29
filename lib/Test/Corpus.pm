module Test::Corpus:auth<github:flussence>:ver<2.0.0-rc.2>;

use Test;

#| Convenience sub for testing filter functions of arity 1
sub simple-test(&func) is export {
    # ^^ This wants to be "&func:(Str --> Str)"

    return sub (IO::Handle $in, IO::Handle $out, Str $testcase) {
        is &func($in.slurp), $out.slurp, $testcase;
    }
}

#| Runs tests on a callback. The callback gets passed input/output filehandles,
#  and the basename of the test file being run. Tests are run in no particular
#  order.
sub run-tests(
    &test,
    Str :$basename = $*PROGRAM_NAME.path.basename,
) is export {
    my @files = dir('t_files/' ~ $basename ~ '.input');

    # If you need multiple tests per file, use &Test::subtest
    plan +@files;

    my sub test-closure($input) {
        return &test.assuming(
            open($input),
            open($input.subst('.input/', '.output/')),
            $input.basename
        );
    }

    # This will parallelise in the future, don't make assumptions about order.
    &test-closure($_).() for @files;

    # Two possible alternatives to the above (note that these both currently
    # crash in MoarVM, so aren't used):
    #   @files».&test-closure».();
    #   await @files».&test-closure».&start;
}

# vim: set tw=80 :
