package Prancer::Plugin::Log4perl;

use strict;
use warnings FATAL => 'all';

use version;
our $VERSION = "1.00";

use Prancer::Plugin;
use parent qw(Prancer::Plugin Exporter);

use Log::Log4perl ();
use Try::Tiny;
use Carp;

our @EXPORT_OK = qw(logger);
our %EXPORT_TAGS = ('all' => [ @EXPORT_OK ]);

# even though this *should* work automatically, it was not
our @CARP_NOT = qw(Prancer Try::Tiny);

sub load {
    my $class = shift;

    # initialize the logger if necessary
    if (!Log::Log4perl->initialized()) {
        Log::Log4perl->init(\qq|
            log4perl.rootLogger = INFO, stdout
            log4perl.appender.stdout = Log::Dispatch::Screen
            log4perl.appender.stdout.stderr = 0
            log4perl.appender.stdout.layout = Log::Log4perl::Layout::PatternLayout
            log4perl.appender.stdout.layout.ConversionPattern = %d{yyyy-MM-dd HH:mm:ss,SSS} %5p [%c{1}:%M:%L] - %m%n
        |);
    }

    return bless({}, $class);
}

sub logger {
    my $package = (caller())[0];
    return Log::Log4perl->get_logger($package);
}

1;

=head1 NAME

Prancer::Plugin::Log4perl

=head1 SYNOPSIS

TODO

=head1 OPTIONS

TODO

=cut
