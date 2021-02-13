#!/usr/bin/perl

use Parallel::ForkManager;

open (FILE4, "<uniqlist.txt");
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

$pm = new Parallel::ForkManager(28);

foreach (@file)
{
$pm -> start and next;
{
print "Processing - - - $_\n";

@fileval = split (/\./, $_);
print "$fileval[0]\n";
@uniq=%seen=();
open(FO,"<$_.ext")||die("No File\n");
while ($line=<FO>)
{
	chomp($line);
	push(@uniq,$line)unless $seen{$line}++; ####taking unique values in array uniq
}
close FO;

open(FW,">$_-uq.uqt")||die("Unable to write to outfile!\n");

foreach $u (@uniq)
{
	$c=0;
	open(FP,"$_.ext")||die("No File!\n");
	while ($inline=<FP>)
	{
		chomp($inline);
		if ($inline eq $u)
		{
			$c++;
		}
	}
	close FP;
	print FW"$u\t$c\n";
}

close FW;
print "Results written to outfile!\n";
$pm->finish;
}
}
$pm->wait_all_children;
