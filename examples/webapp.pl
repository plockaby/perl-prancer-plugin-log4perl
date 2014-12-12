#!/usr/bin/env perl

use strict;
use warnings FATAL => 'all';

use File::Basename ();
use Plack::Runner;

sub main {
    # figure out where exist to make finding config files possible
    my (undef, $root, undef) = File::Basename::fileparse($0);

    # this just returns a PSGI application. $psgi can be wrapped with
    # additional middleware before sending it along to Plack::Runner.
    my $psgi = Foo->new("${root}/foobar.yml")->to_psgi_app();

    # run the psgi app through Plack and send it everything from @ARGV. this
    # way Plack::Runner will get options like what listening port to use and
    # application server to use -- Starman, Twiggy, etc.
    my $runner = Plack::Runner->new();
    $runner->parse_options(@_);
    $runner->run($psgi);

    return;
}

main(@ARGV) unless caller;

package Foo;

use strict;
use warnings FATAL => 'all';

use Prancer qw(config);

# load the logger plugin
use Prancer::Plugin::Log4perl qw(logger);

sub initialize {
    my $self = shift;

    # initialize the logger plugin
    Prancer::Plugin::Log4perl->load();

    return;
}

sub handler {
	my ($self, $env, $request, $response, $session) = @_;

    logger->info("handling request");

    sub (GET + /) {
        $response->header("Content-Type" => "text/plain");
        $response->body("hello, goodbye.");
        return $response->finalize(200);
    }
}

1;

