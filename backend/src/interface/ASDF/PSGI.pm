package ASDF::PSGI;

use strict;
use warnings;

use JSON qw(decode_json encode_json);

my @HEADERS = (
    'Content-Type' => 'application/json',
);

=head2 ASDF::PSGI->new(\%endpoints)

Given a reference to a hash of endpoints, return a new PSGI application. See
the documentation of C<ASDF::Endpoint> for what an endpoint looks like. The
pairs correspond to entries in the hash.

=cut

sub new {
    my ($cls, $endpoints) = @_;
    bless {endpoints => $endpoints}, $cls;
}

=head2 $psgi->handle($env)

Handle a request given a PSGI environment.

=cut

sub handle {
    my ($self, $env) = @_;

    if ($env->{REQUEST_METHOD} eq 'OPTIONS') {
        return ['200', \@HEADERS, ['{}']];
    }

    if ($env->{REQUEST_METHOD} ne 'POST') {
        return ['405', \@HEADERS, ['{}']];
    }

    my $endpoint = $self->{endpoints}->{$env->{REQUEST_URI}};
    unless (defined $endpoint) {
        return ['404', \@HEADERS, ['{}']];
    }

    my ($status, $response) = $endpoint->(do {
        my $input = $env->{'psgi.input'};
        decode_json(do { local $/; <$input> });
    });
    ["$status", \@HEADERS, [encode_json($response)]];
}

1;
