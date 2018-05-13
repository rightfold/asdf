package ASDF::Endpoint;

use strict;
use warnings;

use Exporter qw(import);
use IPC::Run qw(run);

our @EXPORT_OK = qw(endpoint);

=head1 DESCRIPTION

An endpoint in the ASDF interface is a pair (path, handler). The path is a
string that is matched against the request URI using string equality. When
there is a match, the corresponding handler is executed. The handler takes and
returns already-decoded/to-be-encoded JSON objects.

=head2 endpoint($name, \@fields, \&output)

Return an endpoint that reads the given fields from the request body, and
passes them to the named business rule in the declared order. The output
argument receives a string containing the standard output of the business rule,
and should return an object that can be JSON-encoded.

=cut

sub endpoint {
    my ($name, $fields, $output) = @_;
    "/$name", sub {
        my $request = shift;
        my @arguments = map { $request->{$_} } @$fields;
        run ["build/src/business/asdf-$name", @arguments], '>', \my $stdout;
        200, $output->($stdout);
    };
}

1;
