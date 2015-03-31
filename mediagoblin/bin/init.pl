#!/usr/bin/perl
#
# Initialize.
#

use strict;

use UBOS::Logging;
use UBOS::Utils;

my $apache      = $config->getResolve( 'apache2.uname' );
my $appconfigid = $config->getResolve( 'appconfig.appconfigid' );
my $dataDir     = $config->getResolve( 'appconfig.datadir' );

my $confFile = "$dataDir/mediagoblin.ini";
my $cacheDir = "/var/cache/$appconfigid/egg-cache";

my $gmg   = "cd /usr/share/mediagoblin;";
$gmg     .= "sudo -u $apache PYTHON_EGG_CACHE=$cacheDir PYTHONPATH=.:./site-packages site-packages/gmg -cf '$confFile'";

if( 'install' eq $operation || 'upgrade' eq $operation ) {

    # initialize database
    if( UBOS::Utils::myexec( "$gmg dbupdate" )) {
        error( 'Mediagoblin dbupdate failed' );
    }

    # activate basic plugin
    if( UBOS::Utils::myexec( "$gmg assetlink" )) {
        error( 'Mediagoblin dbupdate failed' );
    }
}

1;
