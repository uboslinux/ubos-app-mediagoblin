#!/usr/bin/perl
#
# Simple test for mediagoblin.
#
# This file is part of gladiwashere.
# (C) 2012-2015 Indie Computing Corp.
#
# gladiwashere is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# gladiwashere is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with gladiwashere.  If not, see <http://www.gnu.org/licenses/>.
#

use strict;
use warnings;

package MediagoblinTest1;

use UBOS::WebAppTest;

# The states and transitions for this test

my $TEST = new UBOS::WebAppTest(
    appToTest   => 'mediagoblin',
    description => 'Tests mediagoblin login',
    checks      => [
            new UBOS::WebAppTest::StateCheck(
                    name  => 'virgin',
                    check => sub {
                        my $c = shift;

                        # Front page
                        $c->getMustContain( '/', 'welcome to this MediaGoblin site', undef, 'Wrong front page (logged-off)' );

                        # Login page
                        my $response = $c->getMustContain( '/auth/login/', 'Username or Email', undef, 'Wrong login page' );

                        my $csrfToken = '';
                        if( $response->{content} =~ m!csrf_token.*value="([^"]+)"! ) {
                            $csrfToken = $1;
                        } else {
                            error( 'Cannot find csrf token' );
                        }

                        my $adminData = $c->getTestPlan()->getAdminData();
                            
                        my $postData = {
                                'username'   => $adminData->{userid},
                                'password'   => $adminData->{credential},
                                'csrf_token' => $csrfToken
                        };

                        $response = $c->post( '/auth/login/', $postData );
                        $c->mustRedirect( $response, '/', 302, 'Not redirected to front page' );

                        
                        $c->getMustContain( '/', "There doesn't seem to be any media here yet", undef, 'Wrong front page (logged-in)' );

                        return 1;
                    }
            )
    ]
);

$TEST;
