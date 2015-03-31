#!/usr/bin/perl
#
# Initialize.
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $user = $config->getResolve( 'apache2.uname' );
my $dir  = $config->getResolve( 'appconfig.datadir' );
my $confFile = "$dir/mediagoblin.ini";

if( 'install' eq $operation || 'upgrade' eq $operation ) {

    # initialize database
    if( UBOS::Utils::myexec( "cd /usr/share/mediagoblin/mediagoblin; sudo -u $user ./bin/gmg -cf '$confFile' dbupdate" )) {
        error( 'Mediagoblin dbupdate failed' );
    }

    # activate basic plugin
    if( UBOS::Utils::myexec( "cd /usr/share/mediagoblin/mediagoblin; sudo -u $user ./bin/gmg -cf '$confFile' assetlink" )) {
        error( 'Mediagoblin dbupdate failed' );
    }
}

1;
