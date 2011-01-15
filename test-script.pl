use Test::Tiny tests => 5;
ok(1, 'loaded');
ok(1, 'test 1');
show('1 == "1"', 'Ayn would be proud.');
SKIP: {
    skip "whatever", 2;
}
