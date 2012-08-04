module Test::Corpus;
use Test;

# Get the name of the *.t file being run, and trim directory parts from it.
sub basename {
    # TODO once niecza supports it: return IO::Path($*PROGRAM_NAME).basename;
    ($*PROGRAM_NAME ~~ m{ '/' (<-[/]>+) $ })[0];
}

# Convenience function for your currying amusement
sub simple-test(&func) is export {
    return sub ($in, $out, $filename) {
        is &func($in.slurp), $out.slurp, $filename;
    }
}

# Runs tests on a callback, which gets passed input/output filehandles, and the
# file basename of each.
sub run-tests(
    &test,
    Str :$input-dir = "t_files/{basename}.input",
    Str :$output-dir = "t_files/{basename}.output",
    Int :$tests-per-block = 1,
    Int :$add-to-plan = 0
) is export {
    my @files = dir($output-dir);
    plan $tests-per-block * @files + $add-to-plan;

    for @files -> $filename {
        my $in = open("$input-dir/$filename");
        my $out = open("$output-dir/$filename");

        &test($in, $out, $filename);
    }
}

=comment vim: set tw=80 :
