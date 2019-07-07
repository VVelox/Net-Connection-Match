package Net::Connection::Match;

use 5.006;
use strict;
use warnings;
use Net::Connection;
use base 'Error::Helper';

=head1 NAME

Net::Connection::Match - Runs a stack of checks to match Net::Connection objects.

=head1 VERSION

Version 0.0.0

=cut

our $VERSION = '0.0.0';


=head1 SYNOPSIS

    use Net::Connection::Match;


=head1 METHODS

=head2 new

=cut

sub new{
	my %args;
	if(defined($_[1])){
		%args= %{$_[1]};
	};

	# Provides some basic checks.
	# Could make these all one if, but this provides more
	# granularity for some one using it.
	if ( ! defined( $args{checks} )	){
		die ('No check key specified in the argument hash');
	}
	if ( ref( $args{checks} ) eq 'ARRAY' ){
		die ('The checks key is not a array');
	}
	# Will never match anything.
	if ( ! defined $args{checks}[0] ){
		die ('Nothing in the checks array');
	}
	if ( ref( $args{checks}[0] ) eq 'HASH' ){
		die ('The first item in the checks array is not a hash');
	}

    my $self = {
				perror=>undef,
				error=>undef,
				errorString=>"",
				errorExtra=>{
							 flags=>{
									 1=>'failedCheckInit',
									 }
							 },
				checks=>[],
				};
    bless $self;

	# will hold the created check objects
	my @checks;

	# Loads up each check or dies if it fails to.
	my $check_int=0;
	while( defined( $args{checks}[$check_int] ) ){
		my %new_check=(
					   type=>undef,
					   args=>undef,
					   invert=>undef,
					   );

		# make sure we have a check type
		if ( defined($args{checks}[$check_int]{'type'}) ){
		   $new_check{type}=$args{checks}[$check_int]{'type'};
		}else{
			die('No type defined for check '.$check_int);
		}

		# does a quick check on the tpye name
		my $type_test=$new_check{type};
		$type_test=~s/[A-Za-z0-9]//g;
		$type_test=~s/\:\://g;
		if ( $type_test !~ /^$/ ){
			die 'The type "'.$new_check{type}.'" for check '.$check_int.' is not a valid check name';
		}

		# makes sure we have a args object and that it is a hash
		if (
			( defined($args{checks}[$check_int]{'args'}) ) &&
			( ref( $args{checks}[$check_int]{'args'} ) eq 'HASH' )
			){
		   $new_check{args}=$args{checks}[$check_int]{'args'};
		}else{
			die('No type defined for check '.$check_int.' or it is not a HASH');
		}

		# makes sure we have a args object and that it is a hash
		if (
			( defined($args{checks}[$check_int]{'invert'}) ) &&
			( ref( \$args{checks}[$check_int]{'invert'} ) ne 'SCALAR' )
			){
			die('Invert defined for check '.$check_int.' but it is not a SCALAR');
		}elsif(
			( defined($args{checks}[$check_int]{'invert'}) ) &&
			( ref( \$args{checks}[$check_int]{'invert'} ) eq 'SCALAR' )
			   ){
			$new_check{invert}=$args{checks}[$check_int]{'invert'};
		}

		my $check;
		my $eval_string='use Net::Connection::Match::'.$new_check{type}.';'.
		'$check=Net::Connection::Match::'.$new_check{type}.'->new( $new_check{args} );';
		eval( $eval_string );

		if (!defined( $check )){
			die('Failed to init the check for '.$check_int.' as it returned undef... '.$@);
		}

		$new_check{check}=$check;

		push(@{ $self->{checks} }, \%new_check );

		$check_int++;
	}

	return $self;
}

=head2 matches

Checks if a single Net::Connection object matches the stack.

=cut

sub matches{

}

=head1 AUTHOR

Zane C. Bowers-Hadley, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-net-connection-match at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Net-Connection-Match>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Connection::Match


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Net-Connection-Match>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Net-Connection-Match>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Net-Connection-Match>

=item * Search CPAN

L<https://metacpan.org/release/Net-Connection-Match>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

Copyright 2019 Zane C. Bowers-Hadley.

This program is free software; you can redistribute it and/or modify it
under the terms of the the Artistic License (2.0). You may obtain a
copy of the full license at:

L<http://www.perlfoundation.org/artistic_license_2_0>

Any use, modification, and distribution of the Standard or Modified
Versions is governed by this Artistic License. By using, modifying or
distributing the Package, you accept this license. Do not use, modify,
or distribute the Package, if you do not accept this license.

If your Modified Version has been derived from a Modified Version made
by someone other than you, you are nevertheless required to ensure that
your Modified Version complies with the requirements of this license.

This license does not grant you the right to use any trademark, service
mark, tradename, or logo of the Copyright Holder.

This license includes the non-exclusive, worldwide, free-of-charge
patent license to make, have made, use, offer to sell, sell, import and
otherwise transfer the Package with respect to any patent claims
licensable by the Copyright Holder that are necessarily infringed by the
Package. If you institute patent litigation (including a cross-claim or
counterclaim) against any party alleging that the Package constitutes
direct or contributory patent infringement, then this Artistic License
to you shall terminate on the date that such litigation is filed.

Disclaimer of Warranty: THE PACKAGE IS PROVIDED BY THE COPYRIGHT HOLDER
AND CONTRIBUTORS "AS IS' AND WITHOUT ANY EXPRESS OR IMPLIED WARRANTIES.
THE IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE, OR NON-INFRINGEMENT ARE DISCLAIMED TO THE EXTENT PERMITTED BY
YOUR LOCAL LAW. UNLESS REQUIRED BY LAW, NO COPYRIGHT HOLDER OR
CONTRIBUTOR WILL BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, OR
CONSEQUENTIAL DAMAGES ARISING IN ANY WAY OUT OF THE USE OF THE PACKAGE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


=cut

1; # End of Net::Connection::Match
