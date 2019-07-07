#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Net::Connection::Match::CIDR' ) || print "Bail out!\n";
}

my %args=(
		  cidrs=>[
				  '127.0.0.0/24',
				  '192.168.0.0/16',
				  '10.0.0.0/8'
				  ],
		  );

my $cidr_checker=Net::Connection::Match::CIDR->new( \%args );



#done_testing(23);
