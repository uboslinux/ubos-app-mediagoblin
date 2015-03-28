#!/usr/bin/perl
#
# Install or upgrade the database schema
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $dir = $config->getResolve( 'appconfig.apache2.dir' );

if( 'install' eq $operation || 'upgrade' eq $operation ) {

    if( UBOS::Utils::myexec( "cd '$dir'; ./bin/gmg dbupdate" )) {
        error( 'Mediagoblin dbupdate failed' );
    }
}

1;
