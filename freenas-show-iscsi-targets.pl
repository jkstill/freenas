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

my $diskUrl = '/api/v1.0/services/iscsi/targetgroup/';

my $jsonQuery = '?format=json';

my $req =  HTTP::Request->new( GET => "${baseUrl}${diskUrl}${jsonQuery}");
$req->authorization_basic( "$username", "$password" );

my $page = $browser->request( $req );
#print Dumper(\$page->content);

my $targets = decode_json $page->content;
print Dumper($targets);

exit;

foreach my $el ( 0 .. $#{$targets} ) {

	my $targetHash = $targets->[$el];
	#print Dumper($targetHash);

	print 		qq{
#############################################
 Disk Name : $targetHash->{disk_name}
      ID   : $targetHash->{id}
      Size : $targetHash->{disk_size}
    Serial : $targetHash->{disk_serial}
   Standby : $targetHash->{disk_hddstandby}
Pwr Manage : $targetHash->{disk_advpowermgmt}
};

}



