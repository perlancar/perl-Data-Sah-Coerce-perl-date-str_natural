#!perl

use 5.010001;
use strict;
use warnings;

use Data::Sah::Coerce qw(gen_coercer);
use Test::Exception;
use Test::More 0.98;
use Test::Needs;

subtest "fails -> dies" => sub {
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(type=>"date", coerce_rules=>["str_natural"]);

    # uncoerced
    is_deeply($c->({}), {}, "uncoerced");

    dies_ok { $c->("foo") } qr/Can't parse/;
};

subtest "coerce_to=DateTime" => sub {
    test_needs "DateTime";
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(type=>"date", coerce_to=>"DateTime", coerce_rules=>["str_natural"]);

    # uncoerced
    is_deeply($c->({}), {}, "uncoerced");

    my $d = $c->("may 19, 2016");
    is(ref($d), 'DateTime');
    is($d->ymd, "2016-05-19");
};

subtest "coerce_to=Time::Moment" => sub {
    test_needs "Time::Moment";
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(type=>"date", coerce_to=>"Time::Moment", coerce_rules=>["str_natural"]);

    # uncoerced
    is_deeply($c->({}), {}, "uncoerced");

    my $d = $c->("may 19, 2016");
    is(ref($d), 'Time::Moment');
    is($d->strftime("%Y-%m-%d"), "2016-05-19");
};

subtest "coerce_to=float(epoch)" => sub {
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(type=>"date", coerce_to=>"float(epoch)", coerce_rules=>["str_natural"]);

    # uncoerced
    is_deeply($c->({}), {}, "uncoerced");

    my $d = $c->("may 19, 2016");
    ok(!ref($d));
    is($d, 1463616000);
};

done_testing;
