# colors-0.1c (c) R.Jaksa 2008,2019, GPLv3
# built: ~/prj/libraries/colors/colors.pl
# installed: /map/colors/pl/colors.pl

our $CR_="\033[31m"; # color red
our $CG_="\033[32m"; # color green
our $CY_="\033[33m"; # color yellow
our $CB_="\033[34m"; # color blue
our $CM_="\033[35m"; # color magenta
our $CC_="\033[36m"; # color cyan
our $CW_="\033[37m"; # color white
our $CK_="\033[90m"; # color black
our $CP_="\033[91m"; # color pink
our $CL_="\033[92m"; # color lime
our $CS_="\033[93m"; # color sulphur yellow
our $CZ_="\033[94m"; # color azure
our $CO_="\033[95m"; # color orchid
our $CA_="\033[96m"; # color aqua cyan
our $CF_="\033[97m"; # color fluorescent white
our $CD_="\033[0m";  # color default

# return length of string without escape sequences
our sub esclen {
  my $s = shift;
  $s =~ s/\033\[[0-9]+m//g;
  return length $s; }

