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

my $gmg   = "cd /usr/share/mediagoblin/mediagoblin;";
$gmg     .= "sudo -u $apache PYTHON_EGG_CACHE=$cacheDir PYTHONPATH=.:./site-packages site-packages/gmg -cf '$confFile'";

if( 'install' eq $operation || 'upgrade' eq $operation ) {
    my $out;
    my $err;

    # initialize database
    if( UBOS::Utils::myexec( "$gmg dbupdate", undef, \$out, \$err )) {
        error( 'Mediagoblin dbupdate failed', $out, $err );
    }

    # activate basic plugin
    if( UBOS::Utils::myexec( "$gmg assetlink", undef, \$out, \$err )) {
        error( 'Mediagoblin dbupdate failed', $out, $err );
    }

    # create/update admin user
    my $adminlogin = $config->getResolve( 'site.admin.userid' );
    my $adminpass  = $config->getResolve( 'site.admin.credential' );
    my $adminemail  = $config->getResolve( 'site.admin.email' );

    # gpg always exits with 0
    UBOS::Utils::myexec( "$gmg adduser --username '$adminlogin' --password '$adminpass' --email '$adminemail'", undef, \$out, \$err );
    if( "$out$err" =~ /a user with that name already exists/ ) {
        UBOS::Utils::myexec( "$gmg changepw '$adminlogin' '$adminpass'" );
        
    } else {
        error( 'Mediagoblin adduser failed', $out, $err );
    }
    UBOS::Utils::myexec( "$gmg makeadmin '$adminlogin'", undef, \$out, \$err );
}

1;
