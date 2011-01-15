package Test::Tiny;

=head1 NAME

Test::Tiny -- Write simple tests, simply.

=head1 SYNOPSIS

    use Test::Tiny tests => NUMBER;
    ok(TEST [, MESSAGE]);    # pass if TEST is true, and print MESSAGE
    show(TEST);              # pass if eval(TEST) is true, print TEST
    SKIP: {
        skip(MESSAGE, N);
        # skip this code, including N tests
    }
    BAIL_OUT([MESSAGE]);        # give up, printing MESSAGE.

=cut

$VERSION = '0.01';
$SUCC = 0;
$FAIL = 0;

sub import
{
    my $caller = caller;
    *{"$caller\::$_"} = \&$_ for qw(ok show skip BAIL_OUT);
    die "No plan.\n" unless @_ == 3;
    print '1..', $_[2], "\n";
}

sub ok
{
    my $res = shift;
    if ($res) {
        ++$SUCC
    } else {
        print "not ";
        ++$FAIL;
    }
    my $desc = shift || '';
    print "ok ", $SUCC + $FAIL, ($desc ? " - $desc" : ""), "\n";
    if (!$res) {
        my ($pack, $file, $line, $i);
        ($pack, $file, $line) = caller(++$i) while $pack eq 'Test::Tiny';
        print "# Failed at $file line $line\n";
    }
}

sub show
{
    my $test = shift;
    ok(eval($test), $test);
}

sub skip
{
    my ($why, $n) = @_;
    ok(1, "skipped -- $why") while $n-- > 0;
    last SKIP;
}

sub BAIL_OUT
{
    print "Bail out!", @_, "\n";
    $FAIL = 255; exit $FAIL;
}

END {
    exit($FAIL || abs($PLAN-$SUCC));
}

1;
__END__

=head1 DESCRIPTION

I I<thought> L<Test::Simple> was simple, but then I realized it relies
on L<Test::Builder> to implement the one function it exports.
Test::Tiny does more with less:

=head3 C<ok(TEST [, MESSAGE])>

Print C<"ok N - MESSAGE"> if C<TEST> is true, and C<"not ok N -
MESSAGE"> otherwise.  The C<MESSAGE> is optional.

=head3 C<show(EXPRESSION)>

C<show> is like C<ok>, but uses C<eval(EXPRESSION)> as the C<TEST>,
and uses C<EXPRESSION> as the C<MESSAGE>.  This is useful when your
test is self-explanatory:

    ok sqrt(4) == 2, 'sqrt(4) is 2'; # redundant
    show 'sqrt(4) == 2';             # non-redundant

=head3 C<skip(MESSAGE, NUMBER)>

Skip C<NUMBER> tests with reason C<MESSAGE>:

    SKIP: {
        skip "message", $number;
        # tests go here.
    }

=head3 C<BAIL_OUT(REASON)>

Stop testing for C<REASON>.

=head1 AUTHOR

Sean O'Rourke C<< <seano@cpan.org> >>.

Bug reports welcome, patches even more welcome.

Test::Tiny doesn't try to be 100% compatible with Test::Simple, but
should stay clean, clear, and under 5% of Test::Simple's lines (from
F<Simple.pm>, F<Builder.pm>, and files in F<@INC/Builder>).  Current
counts are:

    Test::Tiny    48   SLOC, 129  lines
    Test::Simple  1345 SLOC, 3612 lines

=head1 COPYRIGHT

Copyright (C) 2010, Sean O'Rourke.
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
