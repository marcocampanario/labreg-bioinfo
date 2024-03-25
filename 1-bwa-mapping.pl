#!/usr/bin/perl 
# script para mapear as reads de um fastq ao genoma referencia pelo algoritimo de Burrow-Wheeler (bwa-mem) em nucleos paralelos
# criado por Flavia Freitas; modificado por Vinicius Parreira, Bruno Janke, Beatriz Azevedo e Marco Campanário
	
use Parallel::ForkManager;

$ENV{'TMPDIR'} = '/complete/path/tmp'; # configura seus processos para rodarem na sua pasta tmp personalizada

my $pm = new Parallel::ForkManager(n); # (n) é a quantidade de processos que quer usar, assim, n processos simultaneos rodarao ao mesmo tempo

@ls=`ls ./*R1*`; # o @ls esta na pasta atual, mas pode ser a lista dos seus arquivos de sequencias

$genome = "/complete/path"; # localizaçao do arquivo do genoma de referencia

# %dict = (535, 'GRUPO A', 4235, 'GRUPO A', 9425, 'GRUPO B', 533, 'GRUPO B', 1773, 'GRUPO C', 1682, 'GRUPO C')
# o dicionario acima e util em caso de necessidade de gerar tag de grupos distintos de amostras;
# caso o script seja rodado uma vez por grupo de amostra isoladamente, nao ha necessidade de dicionario

foreach $l (@ls) {
    chomp($l);
    my $pid =$pm ->start and next;

    $r1=$l;
    $r2=$l;
    $r3=$l;
    @split1=split(/\//, $r3); # pega o nome da amostra, baseado no caminho pwd. O split é pela  "/"
    print ("\nsplit1: @split1\n"); # confere o nome do arquivo
    $r4=@split1[-1]; # -1 é sempre a última posição, logo o nome do arquivo e a ultima posição no pwd;
    @split2=split(/[-_]/, $r4); # quebra o nome do arquivo com split nos caracteres - e _; ESPECÍFICO PARA DADOS DO GRUPO; VERIFICAR O PADRÃO DE NOMENCLATURA DAS SUAS AMOSTRAS
    print ("split2: @split2\n");  # confere o resultado do split e posição das informações
    $sampleNumber = @split2[1]; # ATENÇÃO! pega o ID da amostra, baseado na posição do nome pelo index; exemplo: Exo-R01-0393_S41_L001_R1_001_paired.fastq.gz -> 0393: ID posição, index 2
 #  $sampleType = $dict{$sampleNumber}; # dicionario nao usado como explicado acima
    $sampleType = "BREAST-CANCER"; # tag do grupo das amostras em subsitituição ao dicionário
    $sampleID = $sampleType."_".$sampleNumber; 
    $r2=~s/\_R1\_/\_R2\_/;
    $lib = "LIB-".$sampleID;
    $PU = `zcat $l | head -n1 | sed 's/:/_/g' |cut -d "_" -f1,2,3,4`;  # extrai o código PU do cabeçalho do fastq
    chomp($PU);
	$PU = reverse($PU);
	chop($PU);          # retira um @ do código PU
	$PU = reverse($PU); 
    print ("PU: $PU\n");   # confere o código PU
    $lane = `zcat $l | head -n1 | sed 's/:/_/g' | cut -d "_" -f4`; # extrai a lane do cabeçalho do fastq
    chomp($lane);
    print ("lane: $lane\n"); # confere a lane	
    $out="/home/marco.campanario/storage/WES-CaMama-Jaque/bwa/bwa_files/".$sampleID."_L".$lane."_aln-pe.sam"; # Mudar para o caminho de output dos arquivos #Bruno e Bea #mc

    $cmd = "(time bwa mem -R \"\@RG\\tID:$sampleNumber\\tPL:ILLUMINA\\tPU:$PU\\tLB:$lib\\tSM:$sampleID\" -t 10 $genome $r1 $r2 > $out) > report_".$sampleNumber."_L".$lane.".txt 2>&1 \n"; # além de rodar o bwa-mem, indica o tempo de processamento por lane em reports distintos
#   print $cmd; # confere o comando
    `$cmd`;
    
	$pm -> finish;
    
}
