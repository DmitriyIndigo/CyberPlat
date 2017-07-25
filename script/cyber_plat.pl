#!/usr/bin/perl

use strict;
use utf8;
use open qw(:std utf8);
use warnings FATAL => 'all';

use lib qw(./lib);

use CGI::Application::Server;

use CyberPlat;

my $server = CGI::Application::Server->new(8081);

$server->entry_points({
    '/cyberplat' => 'CyberPlat',
});

$server->run();

1;