module Test::Corpus:auth<github:flussence>:ver<1.1.0>;
use Test;

#= Convenience sub for testing filter functions of arity 1
sub simple-test(&func) is export {
    return sub (IO::Handle $in, IO::Handle $out, Str $testcase) {
        is &func($in.slurp), $out.slurp, $testcase;
    }
}

#= Runs tests on a callback. The callback gets passed input/output filehandles,
#  and the basename of the test file being run.
sub run-tests(
    &test,
    Int :$tests-per-block = 1,
    Str :$basename        = $*PROGRAM_NAME.path.basename
) is export {
    my @files = dir('t_files/' ~ $basename ~ '.input');

    plan @files * $tests-per-block;

    for @files -> $input {
        &test(
            open($input),
            open($input.subst('.input/', '.output/')),
            $input.basename
        );
    }
}

# vim: set tw=80 :
