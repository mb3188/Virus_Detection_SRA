#!/usr/bin/env perl
use warnings;
use strict;
use Getopt::Long;

#reads; NO SUPPORT FOR PAIRED READS

my @prime5 = qw/TGACTGGAGTTCAGACGTGTGCTCTTCCGATCT/;
my @prime3 = qw/AGATCGGAAGAGCACACGTCTGAACTCCAGTCA
                AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATC
                AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT
                /;
my $minlen = 30;
my $rmdefadapters = 0;   # not implemented
my $outputfile;
GetOptions("fiveprime|g=s"    => \@prime5,
           "threeprime|a=s"   => \@prime3,
           "minlen|m=i"        => \$minlen,
           "rm-def-adapters|r" => \$rmdefadapters,
           "outputfile|o=s"    => \$outputfile,
           );

my $usage = <<USAGE;
$0 [options] FASTAFILE
  OPTIONS
    -g    Adapter list for 5' end ( -g ADAPTER1 ... )
    -a    Adapter list for 3' end ( -a ADAPTER2 ... )
    -o    Output file (default: your input sequence file name with ".cutadapt.fa" appended)
    -m    Minimum length cutoff after trimming (default: 50)
    -r    NOT SUPPORTED. If supplied, default adapters (TruSeq) will be removed and not searched for.
USAGE

my $seqs = shift;
die $usage if (!$seqs);

# build cutadapt command line
my @tmp;
my $fiveprime = "";
foreach (@prime5) {
  push (@tmp, "-g $_");
}
$fiveprime = join (" ", @tmp);

@tmp = ();
my $threeprime = "";
foreach (@prime3) {
  push (@tmp, "-a $_");
}
$threeprime = join (" ", @tmp);

$outputfile //= "$seqs.cutadapt.fa";

my $command = "cutadapt $fiveprime $threeprime -m $minlen -o $outputfile $seqs > $seqs.cutadapt.out 2>&1";
print "Running command: $command\n";
`time $command`;

exit 0;
