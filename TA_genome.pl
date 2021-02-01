#/usr/local/bin/
# A script to map TA motif in a given genome. Outputs a tsv file with replicon name, TA, start, end. 

$number_args = $#ARGV + 1;
if ($number_args != 1) {
    print "\nUsage: TA_map.pl genome.fa\n";
    exit;
}

$IPfile=$ARGV[0];

print "Input Genome file: $IPfile\n";


@array = split(/\./,$IPfile);
open IN, "$IPfile";
@genome = <IN>;
close IN;
$ntseq = join( '', @genome);
chomp $ntseq;
$ntseq =~ s/\d|\s//ig;
$len = length($ntseq);
open OUT, ">$array[0]-TA_coordinates.txt";


print "Genome Length of $array[0] is - $len\n";
$offset =0;
@array;
$motif = 'TA';
$result = index($ntseq, $motif, $offset);
$count = 0;
while($result != -1)
{
$start = $result + 1;
$end = $result + 2;
print OUT "$array[0]Chr\tTA\t$start\t$end\n";
push @array, $result;
$offset = $result + 1;
$result = index($ntseq, $motif, $offset);
$count++;
}

print "Total number of TA motifs found - $count\n";
