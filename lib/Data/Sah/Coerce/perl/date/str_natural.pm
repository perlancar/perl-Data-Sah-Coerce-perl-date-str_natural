package Data::Sah::Coerce::perl::date::str_natural;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

sub meta {
    +{
        v => 2,
        enable_by_default => 0,
        might_die => 1,
        prio => 60, # a bit lower than normal
        precludes => [qr/\Astr_alami(_.+)?\z/],
    };
}

sub coerce {
    my %args = @_;

    my $dt = $args{data_term};
    my $coerce_to = $args{coerce_to} // 'float(epoch)';

    my $res = {};

    unless ($coerce_to eq 'DateTime') {
        die "To use this coercion rule, you must coerce your date to DateTime (e.g. by adding this attribute 'x.perl.coerce_to' => 'DateTime' to your schema)";
    }

    $res->{expr_match} = "!ref($dt)";
    $res->{modules}{"DateTime::Format::Natural"} //= 0;
    $res->{expr_coerce} = "DateTime::Format::Natural->new->parse_datetime($dt)";

    $res;
}

1;
# ABSTRACT: Coerce date from string parsed by DateTime::Format::Natural

=for Pod::Coverage ^(meta|coerce)$

=head1 DESCRIPTION

The rule is not enabled by default. You can enable it in a schema using e.g.:

 ["array*", of=>"date", "x.perl.coerce_to"=>"DateTime", "x.perl.coerce_rules"=>["str_natural"]]
