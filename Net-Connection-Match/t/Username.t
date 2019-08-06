#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Net::Connection;

BEGIN {
    use_ok( 'Net::Connection::Match::Username' ) || print "Bail out!\n";
}

my $connection_args={
					 foreign_host=>'10.0.0.1',
					 foreign_port=>'22',
					 local_host=>'10.0.0.2',
					 local_port=>'12322',
					 proto=>'tcp4',
					 state=>'LISTEN',
					 uid=>0,
					 username=>'root'
					 };

my %args=(
		  usernames=>[
					  'root',
					  'foo',
					  ],
		  );
my $checker;

# makes sure we error with empty args
my $worked=0;
eval{
	$checker=Net::Connection::Match::Username->new();
	$worked=1;
};
ok( $worked eq '0', 'empty init check') or diag('Calling new with empty args worked');

# makes sure we can init with good args
$worked=0;
eval{
	$checker=Net::Connection::Match::Username->new( \%args );
	$worked=1;
};
ok( $worked eq '1', 'init check') or diag('Calling Net::Connection::Match::Username->new resulted in... '.$@);

# make sure it will not accept null input
my $returned=1;
eval{
	$returned=$checker->match;
};
ok( $returned eq '0', 'proto undef check') or diag('match accepted undefined input');

# make sure it will not accept a improper ref type
$returned=1;
eval{
	$returned=$checker->match($checker);
};
ok( $returned eq '0', 'match improper ref check') or diag('match accepted a ref other than Net::Connection');

# Create a connection with a matching protocol and see if it matches
my $conn=Net::Connection->new( $connection_args );
$returned=0;
eval{
	$returned=$checker->match( $conn );
};
ok( $returned eq '1', 'match check') or diag('Failed to match a matching good connection');

# Create a connection with a non-matching protocol and make sure it does not match
$connection_args->{username}='linda';
$conn=Net::Connection->new( $connection_args );
$returned=1;
eval{
	$returned=$checker->match( $conn );
};
ok( $returned eq '0', 'non-match check') or diag('Matched a connection that it should not of');

done_testing(7);
