#!/usr/bin/perl
# Copyleft: R.Jaksa 2019, GNU General Public License version 3
# include "CONFIG.pl"
# include "aux.pl"

$HELP=<<EOF;

NAME
    tfnohup2dat - extract data from the tensorflow nohup log

USAGE
    CK(nohup python tf-script.py &)
    tfnohup2dat [OPTIONS] nohup.out > loss.dat
    tfnohup2dat [OPTIONS] -a nohup.out
    tf-script.py | tfnohup2dat

DESCRIPTION
    It extracts the sample number, loss, accuracy, etc. from the TensorFlow
    standard progress report, as stored by nohup.

    Compressed input files file.gz, file.lz, or .zst are also accepted.

OPTIONS
     -h  This help.
     -v  Verbose messaging.
     -a  Automatic output file(s) file.dat (file-N.dat).  Multiple-files
         output for the multi-run nohup.out is possible in this mode.
     -r  Print raw input with non-ASCII characters removed.

EOF

# -----------------------------------------------------------------------------

# key/value verbose message
our sub verbose { print STDERR "$CC_$_[0]:$CD_ $_[1]$CD_\n" if $VERBOSE; }

# -----------------------------------------------------------------------------

for(@ARGV) { if($_ eq "-h") { printhelp $HELP; exit 0; }}
for(@ARGV) { if($_ eq "-v") { $VERBOSE=1; $_=""; last; }}
for(@ARGV) { if($_ eq "-a") { $AUTO=1; $_=""; last; }}
for(@ARGV) { if($_ eq "-r") { $RAW=1; $_=""; last; }}

our $FILE;
for(@ARGV) {
  next if $_ eq "";
  if(-f $_) { $FILE=$_; $_=""; last; }}
verbose "input",$FILE if $FILE;

# -----------------------------------------------------------------------------

our $STREAM = 1 if not defined $FILE;
our $EPOCHS;
our $EPOCH = 0;
our $STEPS;
our $STEP = 1;
our $PAT = 0;

# ------------------------------------------------------------- OUTPUT HANDLING
my @OUT;	# output array
my $NOUT = 0;	# number of outputs
##my $OUTPUT;	# filehandle

sub newoutput {
  return if not $AUTO;
  my $new = $FILE;
  $new =~ s/\..*?$//;
  $new = "nohup" if $new eq "";

  # define the output filename
  if($NOUT==0) {
    $new .= ".dat"; }
  elsif($NOUT==1) {
    verbose "rename","$new.dat -> $new-1.dat";
    system "mv $new.dat $new-1.dat";
    $new .= "-2.dat"; }
  else {
    $new .= "-".($NOUT+1).".dat"; }
  verbose "output",$new;

  # close/open the file
  close(OUTPUT) if $NOUT!=0;
  if(not open OUTPUT,">$new") {
    print STDERR "${CR_}Can't create file \"$new\" ($!).$CD_\n";
    exit 1; }

  $NOUT++; }

# emit data line into file or STDOUT
sub output {
  my $line = $_[0];
  if($AUTO) {
    print OUTPUT "$line\n"; }
  else {
    print "$line\n"; }}

# ---------------------------------------------------------------------- HEADER
our $HASHDR;
our @HDR;

sub hdr2str {
  my $s = "#pat";
  $s .= " $_" for @HDR;
  return $s; }

# -----------------------------------------------------------------------------
my $RE1 = qr(Epoch ([0-9]+)\/([0-9]+));
my $RE2 = qr(^\h*([0-9]+)\/([0-9]+).*? loss: [0-9\.]+);

# parse the line
sub parseline {
  my $line = $_[0];

  $line =~ s/\033\[[0-9]+m//g;	# remove colors escapes
  $line =~ s/[^ -~]//g;		# remove everything out of ASCII range = control chars

  # raw output
  if($RAW) {
    print "$line\n";
    next; }

  # new epoch
  if($line =~ /$RE1/) {
    $EPOCHS = $2 if not defined $EPOCHS;
    if($1==1 and $EPOCH>0) { # start of new training section
      $HASHDR = 0;
      @HDR = (); }
    $EPOCH = $1-1;
    # print STDERR "$line (epoch: $EPOCH)\n";
    next; }

  # data line
  elsif($line =~ /$RE2/) {
    $STEPS = $2; # should not change however
    $STEP = $1;
    $PAT = $EPOCH*$STEPS + $STEP;

    # get keys header
    if(!$HASHDR) {
      my $l = $line;
      my @hdr;
      while($l =~ s/([a-zA-Z0-9_]+): [0-9\.]+//) {
	my $k = $1;
	next if $k eq "ETA";
	push @hdr,$k; }
      push @HDR,$_ for @hdr;
      push @HDR,"val_$_" for @hdr;
      newoutput;
      output hdr2str;
      $HASHDR = 1; }

    # get values
    my %val = ();
    for my $k (@HDR) {
      $val{$k} = $1 if $line =~ / $k: ([0-9\.e-]*)/; }

    # defaults
    for my $k (@HDR) {
      $val{$k} = NaN if not defined $val{$k}; }

    # print
    my $s = "$PAT";
      $s .= " $val{$_}" for @HDR;
    output $s; }}

# -----------------------------------------------------------------------------

# streaming
if($STREAM) {
  while(<STDIN>) {
    for my $line (split /[\n\r]+/,$_) { # we have to further split the <> by \r
      parseline $line; }}}

# loop through all lines of input file
else {
  my $s;
  if($FILE =~ /\.zst$/)	   { $s = `zstdcat $FILE`; }
  elsif($FILE =~ /\.lz$/)  { $s = `lzip -c -d $FILE`; }
  elsif($FILE =~ /\.gz$/)  { $s = `zcat $FILE`; }
  else			   { $s = `cat $FILE`; }
  for my $line (split /[\n\r]+/,$s) {
    parseline $line; }}

close(OUTPUT) if $AUTO;

# -----------------------------------------------------------------------------
