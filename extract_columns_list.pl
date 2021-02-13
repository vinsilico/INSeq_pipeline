#!/usr/local/bin/perl

# A program to copy few columns from a file

open (FILE4, "<extlist.txt");
while ($fileline = <FILE4>)
        {
        chomp $fileline;
       @list = split (/\./, $fileline);
        #print "$list[0]\n";
        push (@file, $list[0]);
        @list = ' ';
        }
        $fileno = $#file+1;

close FILE4;
print "Total Number of files to process = $fileno\n\n";
for ($i=0; $i <  $fileno; $i++)
{ print "$file[$i]\n"; }
print "\n";

foreach (@file)
{
print "Processing - - - $_\n";

@fileval = split (/\./, $_);
print "$fileval[0]\n";
open(FILE, "<$fileval[0].bed");
open OUT, ">$_.ext";
$count=0;
while($newline = <FILE> )
{
chomp $newline;
@elements = split('\t', $newline);
print OUT "$elements[1]\t$elements[5]\n";
$count = $count+1;

}
print "$count\n";
}
close OUT;
close FILE;
