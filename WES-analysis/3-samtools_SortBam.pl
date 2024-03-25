#!/usr/bin/perl
# script para organizar os arquivos .bam com base nas coordenadas genômicas, em nucleos paralelo

use Parallel::ForkManager;

$ENV{'TMPDIR'} = '/complete/path/tmp'; # configura seus processos para rodarem na sua pasta tmp personalizada

my $pm = new Parallel::ForkManager(n); # (n) é a quantidade de processos que quer usar, assim, n processos simultaneos rodarao ao mesmo tempo

@ls=`ls *.bam`; # o @ls esta na pasta atual, mas pode ser a lista dos seus arquivos de sequencias

foreach $l (@ls) {
    chomp($l);
    my $pid =$pm ->start and next;
    
    print "arquivo: $l\n";
    $r1=$l;
    $r2=$l;
    $r2=~s/.bam/_sorted.bam/;
    # print "input: $r1\n"; confere o input
    # print "output: $r2\n"; confere o output

    $cmd = "samtools sort -@ 10 $r1 -o $r2"; # argumento -@: numero de threads, no exemplo 10 threads sao chamadas
    # print "$cmd\n"; confere o codigo

    `$cmd`;
    $pm -> finish;
    
}
