# corelib-0.1 (c) R.Jaksa 2012,2019, GPLv3
# built: ~/prj/libraries/corelib/corelib.pl
# installed: /map/corelib/pl/corelib.pl

{

# inar(\@a,$s) - check whether the string is in the array
our sub inar {
  my $a = shift; # array ref
  my $s = shift; # string
  foreach(@{$a}) { return 1 if $_ eq $s; }
  return 0; }

# pushq(\@a,$s) - push unique, only if not there
our sub pushq {
  my $a = shift; # array ref
  my $s = shift; # string
  return if inar $a,$s;
  push @{$a},$s; }

# pushacp(\@a,\@a2) - make copy of a2 and push ref to it
our sub pushacp {
  my $a  = shift;	# target array ref
  my @a2 = @{shift()};	# copy of array
  push @{$a},\@a2; }

}

