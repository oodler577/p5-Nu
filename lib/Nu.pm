package Nu;

use strict;
use warnings;

our $VERSION = q{0.1};
use Exporter qw/import/;
our @EXPORT    = qw(new has pkg true);
our @EXPORT_OK = qw(new has pkg true);

require Data::Dumper;

our $PACKAGE;

sub pkg (;$) {
  my $pkg = shift;
  if ( $pkg ) {
    $PACKAGE = $pkg;
  } 
  return $PACKAGE;
}

sub new (&;@) {
    unshift @_, q{_new};
    my %stuff = @_;

    # create the 'new' subroutine
    no strict qw/refs/;
    my $new = sprintf qq{%s::new}, pkg;
    *{$new} = sub {
       my ($pkg, %opts) = @_;
       $stuff{_new}->($pkg);
       print Data::Dumper::Dumper(\%opts);
     };

    print Data::Dumper::Dumper( \%stuff );
}

sub has (@) {
    return q{has}, @_;
}

sub true {
  1;
};

1;

__END__

=head1 NAME

Nu - Perl OOP keywords operating within the constraints of traditional
prototypes to provide a constructor generator.

=head1 SYNOPSIS

  # lib/My/Farp.pm
  package My::Farp;
  use Nu; # exports: new, has, pkg

  # constructor constructor
  new {
    my $pkg = pkg; # really just for feels

    # of the blessed instance is implied
  }
  has fields      => [qw/field1=$ field2=@ field3=% field4=i field5=s/]
  has methods     => [qw/farp fart ooze/]
  has roles       => [qw/IDK::What::A::Role::IS ROLE::Another::One CANT::EVEN/]
  has description => q{Farp is like a fart but when made from a whoopie cushion, a human armpit, or gelatious putty in the hand.}
  has validation {
      # rules that are passed on to Validate::Tiny
      {
          # List of fields to look for
          fields => [qw/name email pass pass2 gender/],
          # Filters to run on all fields
          filters => [
              # Remove spaces from all
              qr/.+/ => filter(qw/trim strip/),
              # Lowercase email
              email => filter('lc'),
              # Remove non-alphanumeric symbols from
              # both passwords
              qr/pass?/ => sub {
                  $_[0] =~ s/\W/./g;
                  $_[0];
              },
          ],
          # Checks to perform on all fields
          checks => [
              # All of these are required
              [qw/name email pass pass2/] => is_required(),
              # pass2 must be equal to pass
              pass2 => is_equal('pass'),
              # custom sub validates an email address
              email => sub {
                  my ( $value, $params ) = @_;
                  return if Email::Valid->address($value);
                  return 'Invalid email';
              },
              # custom sub to validate gender
              gender => sub {
                  my ( $value, $params ) = @_;
                  return if $value eq 'M' || $value eq 'F';
                  return 'Invalid gender';
              }
          ]
      }
  };

...

  use My::Farp qw//;

  my $farp = My::Farp->new( field1 => 1, field2 => [qw/foo bar baz/], field3 => { herp => derp }, field4 => 1, field5 => q{flart} );
  printf qq{%s\n}, $farp=>field5;
  foreach my $f ($farp->farp->fart->ooze->field2) {
    print qq{$f!\n};
  } 
