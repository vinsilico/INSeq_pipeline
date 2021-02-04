#/usr/local/bin/
# A script to map TA motif in a given genome. Outputs a tsv file with replicon name, TA, start, end. 

#Check for input genome file and return usage if no input file
$number_args = $#ARGV + 1;
if ($number_args != 1) {
    print "\nUsage: TA_genome.pl genome.fa\n";
    exit;
}
$IPfile=$ARGV[0];print "Input Genome file: $IPfile\n";

#Read the file content into an array and clean the genome sequence
@array = split(/\./,$IPfile);
open IN, "$IPfile";
@genome = <IN>;
close IN;
$ntseq = join( '', @genome);
chomp $ntseq;
$ntseq =~ s/\d|\s//ig;
$len = length($ntseq);

#open a file to write
open OUT, ">$array[0]-TA_coordinates.txt";




print "Genome Length of $array[0] is - $len\n";
$offset =0;
@array;
#$motif = 'TA'
$motif = 'ta';
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
