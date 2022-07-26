#!/usr/bin/env perl
use strict;
use warnings;
use Nu;

# constructor constructor
pkg 'My::Thing';

new {
  my ($pkg, %opts) = @_;
  print qq{$pkg\n};
}
has {
  ISA         => [qw/My Other::Thing/],
  fields      => [qw/field1=$ field2=@ field3=% field4=i field5=s/],
  methods     => [qw/farp fart ooze/],
  description => q{Farp is like a fart but when made from a gelatious putty in the hand.},
};

sub farp {
  print qq{farp\n};
}

sub fart {
  print qq{fart\n};
}

sub ooze {
  print qq{ooze\n};
}

true;
