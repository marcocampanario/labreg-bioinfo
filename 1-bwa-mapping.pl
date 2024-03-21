#!/usr/bin/perl 
# script para alinhar com o bwa em paralelo
# criado por Flavia Freitas; modificado por Vinicius Parreira (#vp) e por Bruno Janke e Beatriz Azevedo e por Marco Campanário
	
use Parallel::ForkManager;

my $pm = new Parallel::ForkManager(3); #### entre (n) a quantidade de processos que quer usar, assim, n processos simultaneos rodarao ao mesmo tempo

@ls=`ls ./*R1*`;

# o @ls está na pasta atual, mas pode ser a lista dos seus arquivos de sequencias

$genome = "/LABREG-PASSETTI-01/beatriz.azevedo/genoma/hg38.fa"; #localização do arquivo do genoma de referência #Bruno e Bea #mc

# %dict = (535, 'MISC', 4235, 'MISC', 9425, 'MISC', 533, 'MISC', 1773, 'MISC',1682, 'MISC',1895, 'MISC',6549, 'MISC',1890, 'MISC',6151, 'MISC',264, 'MISC',259, 'MISC',1842, 'MISC',392, 'MISC',1301, 'MISC',301, 'MISC',91, 'MISC',76, 'MISC',144, 'MISC',427, 'MISC',300, 'MISC',402, 'MISC',2261, 'MISC',2230, 'MISC',299, 'MISC',2498, 'MISC',2493, 'MISC',1004, 'COVID',1319, 'COVID',1384, 'COVID',1780, 'COVID',1777, 'COVID',1836, 'COVID',1949, 'COVID',1937, 'COVID',1943, 'COVID',521, 'COVID',999,'COVID',3245,'MISC',3587,'MISC',3708,'MISC');
# O dicionário acima é útil em caso de necessidade de gerar tag de grupos distintos. Vamos rodar o scrip por grupo então não será usado por #Bruno e Bea

foreach $l (@ls) {
    chomp($l);
    my $pid =$pm ->start and next;

    $r1=$l;
    $r2=$l;
    $r3=$l;
    @split1=split(/\//, $r3); # Pega o nome da amostra, baseado no caminho pwd. O split é pela  "/" #vp #Bruno e Bea
    print ("\nsplit1: @split1\n"); # apenas para conferir o nome do arquivo
    $r4=@split1[-1]; # -1 é sempre a última posição, logo o nome do arquivo é a última posição no pwd. Exemplo: /home/bruno.nascimento/storage/COVID-Leve/FASTQ/Exo-R01-0393_S41_L001_R1_001_paired.fastq.gz #Bruno e Bea
    @split2=split(/[-_]/, $r4); #  Quebra o nome do arquivo com split nos caracteres - e _ #Bruno e Bea
    print ("split2: @split2\n");  # conferir o resultado do split e posição das informações
    $sampleNumber = @split2[1]; # ATENÇÃO! pega o ID da amostra, baseado na posição do nome pelo index. Exemplo: Exo-R01-0393_S41_L001_R1_001_paired.fastq.gz  0393 é a ID posição index 2 #vp #Bruno e Bea mudei para [1] porque meus arquivos têm outro padrão de nome Exoma-1015_S181_L001_R1_001_paired.fastq.gz #mc
 #  $sampleType = $dict{$sampleNumber}; #não usado devido a ser rodado o script uma vez por grupo #Bruno e Bea
    $sampleType = "BREAST-CANCER"; # Tag do grupo das amostras em subsitituição ao dicionário #Bruno e Bea
    $sampleID = $sampleType."_".$sampleNumber;
    $r2=~s/\_R1\_/\_R2\_/;
    $lib = "LIB-".$sampleID;
    $PU = `zcat $l | head -n1 | sed 's/:/_/g' |cut -d "_" -f1,2,3,4`;  # extrai o código PU do cabeçalho do fastq
    chomp($PU);
	$PU = reverse($PU);
	chop($PU);          # retirar um @ do código PU
	$PU = reverse($PU); 
    print ("PU: $PU\n");   # conferir o código PU
    $lane = `zcat $l | head -n1 | sed 's/:/_/g' | cut -d "_" -f4`; # extrai a lane do cabeçalho do fastq
    chomp($lane);
    print ("lane: $lane\n"); # conferir a lane	
    $out="/home/marco.campanario/storage/WES-CaMama-Jaque/bwa/bwa_files/".$sampleID."_L".$lane."_aln-pe.sam"; # Mudar para o caminho de output dos arquivos #Bruno e Bea #mc

    $cmd = "(time bwa mem -R \"\@RG\\tID:$sampleNumber\\tPL:ILLUMINA\\tPU:$PU\\tLB:$lib\\tSM:$sampleID\" -t 10 $genome $r1 $r2 > $out) > report_".$sampleNumber."_L".$lane.".txt 2>&1 \n";
#   print $cmd;
    `$cmd`;	
    	#`bwa mem -R '\@RG\\tID:$sampleNumber\\tPL:ILLUMINA\\tPU:VH00451_1_AAAGH5LHV\\tLB:$lib\\tSM:$sampleID' -t 15 genome/fasta/Hs.hg19.fa $r1 $r2 > $out`;
    
	$pm -> finish;
    
}
