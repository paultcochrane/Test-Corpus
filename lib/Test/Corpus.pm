module Test::Corpus:auth<github:flussence>:ver<1.0.0>;
use Test;

sub test-basename {
    return $*PROGRAM_NAME.path.basename;
}

# Convenience sub for testing filter functions of arity 1
sub simple-test(&func) is export {
    return sub ($in, $out, $filename) {
        is &func($in.slurp), $out.slurp, $filename;
    }
}

# Runs tests on a callback. This gets passed an input filehandle, an output
# filehandle, and the filename each is derived from.
sub run-tests(
    &test,
    Str :$input-dir = "t_files/{test-basename}.input",
    Str :$output-dir = "t_files/{test-basename}.output",
    Int :$tests-per-block = 1,
    Int :$add-to-plan = 0
) is export {
    my @files = dir($output-dir);
    plan $tests-per-block * @files + $add-to-plan;

    for @files».path».basename -> $basename {
        my $in = open("$input-dir/$basename");
        my $out = open("$output-dir/$basename");

        &test($in, $out, $basename);
    }
}

=comment vim: set tw=80 :
