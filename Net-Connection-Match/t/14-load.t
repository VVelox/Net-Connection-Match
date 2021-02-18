#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'Net::Connection::Match::All' ) || print "Bail out!\n";
}

diag( "Testing Net::Connection::Match::All $Net::Connection::Match::All::VERSION, Perl $], $^X" );
