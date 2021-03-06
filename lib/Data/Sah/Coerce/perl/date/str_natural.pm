package Data::Sah::Coerce::perl::date::str_natural;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

use Data::Dmp;

# TMP
our $time_zone = 'UTC';

sub meta {
    +{
        v => 3,
        enable_by_default => 0,
        might_fail => 1,
        prio => 60, # a bit lower than normal
        precludes => [qr/\A(str_alami(_.+)?|str_flexible)\z/],
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};
    my $coerce_to = $args{coerce_to} // 'float(epoch)';

    my $res = {};

    $res->{expr_match} = "!ref($dt)";
    $res->{modules}{"DateTime::Format::Natural"} //= 0;
    $res->{expr_coerce} = join(
        "",
        "do { my \$p = DateTime::Format::Natural->new(time_zone => ".dmp($time_zone)."); my \$datetime = \$p->parse_datetime($dt); ",
        "if (!\$p->success) { [\$p->error] } else { ",
        ($coerce_to eq 'float(epoch)' ? "[undef, \$datetime->epoch] " :
             $coerce_to eq 'Time::Moment' ? "[undef, Time::Moment->from_object(\$datetime)] " :
             $coerce_to eq 'DateTime' ? "[undef, \$datetime] " :
             (die "BUG: Unknown coerce_to '$coerce_to'")),
        "} }",
    );

    $res;
}

1;
# ABSTRACT: Coerce date from string parsed by DateTime::Format::Natural

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["date", "x.perl.coerce_rules"=>["str_natural"]]
