use Test::Simple tests => 1;
ok(`$^X -Mblib test-script.pl` eq <<'EOS', 'loaded');
1..5
ok 1 - loaded
ok 2 - test 1
ok 3 - 1 == "1"
ok 4 - skipped -- whatever
ok 5 - skipped -- whatever
EOS
