#!/usr/bin/perl
# script para transformar arquivos .sam para arquivos .bam usando núcleos em paralelo

$ENV{'TMPDIR'} = '/complete/path/tmp'; # configura seus processos para rodarem na sua pasta tmp personalizada

use Parallel::ForkManager;

my $pm = new Parallel::ForkManager(n); # (n) é a quantidade de processos que quer usar, assim, n processos simultaneos rodarao ao mesmo tempo

@ls=`ls *sam`; # o @ls esta na pasta atual, mas pode ser a lista dos seus arquivos de sequencias

foreach $l (@ls) {
    chomp($l);
    my $pid =$pm ->start and next;

    print ("arquivo: $l\n");
    $r1=$l;
    $r2=$l;
    $r2=~s/sam/bam/;
    $r2=~s/bwa_files/bam_files/;
	
    $cmd = "samtools view -@ 4 -S -b $r1 -o $r2";
    #print $cmd\n;  # confere o comando 
    `$cmd`;
    $pm -> finish;
    
}
