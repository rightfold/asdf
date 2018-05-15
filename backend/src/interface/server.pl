use strict;
use warnings;

use ASDF::Endpoint qw(endpoint);
use ASDF::PSGI;
use Plack::Handler::FCGI;

my %ENDPOINTS = (
    endpoint(
        'append-to-ledger',
        [qw(group type comment debitor creditor amount)],
        sub { {transaction_id => shift} },
    ),
    endpoint(
        'create-group',
        [qw(name)],
        sub { {group_id => shift} },
    ),
    endpoint(
        'list-ledger',
        [qw(group)],
        sub {
            my @transactions = map { [split /\t/] } split(/\n/, shift);
            {transactions => \@transactions};
        },
    ),
    endpoint(
        'log-in',
        [qw(email_address password)],
        sub { {token => shift} },
    ),
);

my $app = ASDF::PSGI->new(\%ENDPOINTS);

my $server = Plack::Handler::FCGI->new(
    listen => ['127.0.0.1:8081'],
    keep_stderr => 1,
);
$server->run(sub { $app->handle(@_); });
