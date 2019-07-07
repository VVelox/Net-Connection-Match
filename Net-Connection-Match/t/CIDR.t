#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

BEGIN {
    use_ok( 'Net::Connection::Match::CIDR' ) || print "Bail out!\n";
}


my %bad_args=(
		  cidrs=>[
				  '10.0.0.0/33'
				  ],
		  );

my %args=(
		  cidrs=>[
				  '127.0.0.0/24',
				  '192.168.0.0/16',
				  '10.0.0.0/8'
				  ],
		  );
my $cidr_checker;

# makes sure we error with empty args
my $worked=0;
eval{
	$cidr_checker=Net::Connection::Match::CIDR->new();
	$worked=1;
};
ok( $worked eq '0', 'empty init check') or diag('Calling new with empty args worked');

# makes sure we can init with good args
$worked=0;
eval{
	$cidr_checker=Net::Connection::Match::CIDR->new( \%bad_args );
	$worked=1;
};
ok( $worked eq '0', 'bad CIDR init check') or diag('new accepts invalid CIDRs');

# makes sure we can init with good args
$worked=0;
eval{
	$cidr_checker=Net::Connection::Match::CIDR->new( \%args );
	$worked=1;
};
ok( $worked eq '1', 'init check') or diag('Calling Net::Connection::Match::CIDR->new resulted in... '.$@);

# make sure it will not accept null input
my $returned=1;
eval{
	$returned=$cidr_checker->match;
};
ok( $returned eq '0', 'match undef check') or diag('match accepted undefined input');

# make sure it will not accept null input
$returned=1;
eval{
	$returned=$cidr_checker->match($cidr_checker);
};
ok( $returned eq '0', 'match improper ref check') or diag('match accepted a ref other than Net::Connection');

done_testing(6);
