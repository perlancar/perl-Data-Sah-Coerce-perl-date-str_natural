#!perl

use 5.010001;
use strict;
use warnings;
use Test::More 0.98;
use Test::Needs;

use Data::Sah::Coerce qw(gen_coercer);

subtest "fails -> dies" => sub {
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(
        type=>"date",
        coerce_rules=>["str_natural"],
        return_type => "status+err+val",
    );

    my $res;

    # uncoerced
    $res = $c->({});
    ok(!$res->[0]);
    is_deeply($res->[2], {});

    # fail
    $res = $c->("foo");
    ok($res->[0]);
    ok($res->[1]);
    is_deeply($res->[2], undef);
};

subtest "coerce_to=DateTime" => sub {
    test_needs "DateTime";
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(type=>"date", coerce_to=>"DateTime", coerce_rules=>["str_natural"]);

    my $d = $c->("may 19, 2016");
    is(ref($d), 'DateTime');
    is($d->ymd, "2016-05-19");
};

subtest "coerce_to=Time::Moment" => sub {
    test_needs "Time::Moment";
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(type=>"date", coerce_to=>"Time::Moment", coerce_rules=>["str_natural"]);

    my $d = $c->("may 19, 2016");
    is(ref($d), 'Time::Moment');
    is($d->strftime("%Y-%m-%d"), "2016-05-19");
};

subtest "coerce_to=float(epoch)" => sub {
    test_needs "DateTime::Format::Natural";

    my $c = gen_coercer(type=>"date", coerce_to=>"float(epoch)", coerce_rules=>["str_natural"]);

    my $d = $c->("may 19, 2016");
    ok(!ref($d));
    is($d, 1463616000);
};

done_testing;
