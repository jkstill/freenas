#!/usr/local/bin/perl -w

use warnings;
use strict;
use Data::Dumper;
use JSON;
use LWP::UserAgent;


open PASSWD, '<', 'password.txt' || die "Could not open password.txt - $! \n";
open CONFIG, '<', 'config' || die "Could not open config - $! \n";

my $username=<PASSWD>;
chomp $username;
my $password=<PASSWD>;
chomp $password;

my %config=();
while (<CONFIG>) {
	chomp;
	my ($parameter,$value) = split(/\s*=\s*/);
	$config{$parameter} = $value
}

my $browser = LWP::UserAgent->new;
my $baseUrl=$config{url};

my $diskUrl = '/api/v1.0/services/iscsi/globalconfiguration/';

my $jsonQuery = '?format=json';

my $req =  HTTP::Request->new( GET => "${baseUrl}${diskUrl}${jsonQuery}");
$req->authorization_basic( "$username", "$password" );

my $page = $browser->request( $req );
#print Dumper(\$page->content);

my $globals = decode_json $page->content;
#print Dumper($globals);

print qq{
#############################################
      ID   : $globals->{id}
      Name : $globals->{iscsi_basename}
};




