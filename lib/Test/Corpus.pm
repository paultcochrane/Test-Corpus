module Test::Corpus;
use Test;

#= Get the name of the *.t file being run, and trim directory parts from it.
sub basename {
    ($*PROGRAM_NAME ~~ m{ '/' (<-[/]>+) $ })[0];
}

#= Runs tests on a callback, which gets passed input/output filehandles, and the
#  file basename of each.
our sub run-tests(
    Callable $test-block,
    Str :$input-dir = "t_files/{basename}.input",
    Str :$output-dir = "t_files/{basename}.output",
    Int :$tests-per-block = 1,
    Int :$add-to-plan = 0
) {
    my @files = dir($output-dir);
    plan $tests-per-block * @files + $add-to-plan;

    for @files -> $filename {
        my $in = open("$input-dir/$filename");
        my $out = open("$output-dir/$filename");

        $test-block($in, $out, $filename);
    }
}

=comment vim: set tw=80 :