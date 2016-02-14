#!/usr/local/bin/perl -w

use warnings;
use strict;
use Data::Dumper;
use JSON;
use LWP::UserAgent;


open PASSWD, '<', 'password.txt' || die "Could not open password.txt - $! \n";

my $username=<PASSWD>;
chomp $username;
my $password=<PASSWD>;
chomp $password;

my $browser = LWP::UserAgent->new;
my $baseUrl='http://lestrade.jks.com';

my $diskUrl = '/api/v1.0/storage/disk/';

my $jsonQuery = '?format=json';

my $req =  HTTP::Request->new( GET => "${baseUrl}${diskUrl}${jsonQuery}");
$req->authorization_basic( "$username", "$password" );

my $page = $browser->request( $req );
print Dumper(\$page->content);




