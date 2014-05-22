module Test::Corpus:auth<github:flussence>:ver<2.0.0-rc>;

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
    Str :$basename = $*PROGRAM_NAME.path.basename,
    Str :$parallel = %*ENV<TEST_CORPUS_PARALLEL> // 'serial'
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

    # Technically these should all work, but right now none do.
    # (tested on Rakudo 2014.07-6-g8668171aa34a)
    given $parallel {
        when 'serial' {
            @files.map(&test-closure);
        }
        when 'hyper' {
            @files».&test-closure».();
        }
        when 'threads' {
            await @files».&test-closure».&start;
        }
        default { ??? }
    }
}

# vim: set tw=80 :
