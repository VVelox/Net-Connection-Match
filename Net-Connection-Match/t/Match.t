#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Net::Connection;

BEGIN {
    use_ok( 'Net::Connection::Match' ) || print "Bail out!\n";
}

my $connection_args={
					  foreign_host=>'10.0.0.1',
					  foreign_port=>'22',
					  local_host=>'10.0.0.2',
					  local_port=>'12322',
					  proto=>'tcp4',
					  state=>'LISTEN',
					  };

my %args=(
		  testing=>1,
		  checks=>[
				   {
					type=>'Ports',
					invert=>0,
					args=>{
						   ports=>[
								   '22',
								   ],
						   lports=>[
									'53',
									],
						   fports=>[
									'12345',
									],
						   }
					}
				   ]
		  );
my $checker;

# makes sure we error with empty args
my $worked=0;
eval{
	$checker=Net::Connection::Match->new();
	$worked=1;
};
ok( $worked eq '0', 'empty init check') or diag('Calling new with empty args worked');

# makes sure we can init with good args
$worked=0;
eval{
	$checker=Net::Connection::Match->new( \%args );
	$worked=1;
};
ok( $worked eq '1', 'init check') or diag('Calling Net::Connection::Match::Ports->new resulted in... '.$@);

# make sure it will not accept a improper ref type
my $returned;
eval{
	$returned=$checker->match($checker);
};
ok( $checker->error eq '2', 'match improper ref check') or diag('match accepted a ref other than Net::Connection');


# make sure it will not accept null input
eval{
	$returned=$checker->match();
};
ok( $checker->error eq '2', 'match null input check') or diag('match accepted a ref other than Net::Connection');

done_testing(5);
