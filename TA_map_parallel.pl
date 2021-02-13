#!/usr/local/bin/perl
# Program to count the number of reads matching to the predicted TA site - modified the original TAmapparallel.pl on July2015
# works only with the sorted column of start coordinate of the input file(filename-uq.ext) output of map_unique.pl
# modified on 31-Mar-2016

use Parallel::ForkManager;

open (FILE4, "<bedlist.txt");
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

@fileval = split (/-/, $_);

print "$fileval[1]\n";
$start_time = time();

open(ANNO, "<$fileval[1]-TA.bedg");
open FILE1, ">$_-TAcount.wig";
$count=0;
$counth=0;
$readcounts1=0;
$countgr=0;
%percent=0.00;
$lavan=0;
while($annoline = <ANNO> )
        {
        chomp ($annoline);
        @anno1 = split ('\t', $annoline);
        $count++;
        open(READS, "<$_.uqt");
         while ($readline = <READS> )
                {
                chomp $readline;
                @reads = split ('\t', $readline);
                if (($reads[0] >= ($anno1[1]-2)) && ($reads[0] <= ($anno1[1]+2)))
                        {
                        $counth++;
                        $lavan += $reads[2];
                        #print FILE1 "$anno1[1]\t$reads[2]\n";
                        }
                }
                print FILE1 "$anno1[1]\t$lavan\n";
                $counth=0;
                $lavan=0;
                next;
                if ($reads[0] <= $anno1[1])
                {
                last;
                }
       }
$end_time = time();
       open(READS1, "<$fileval[0]-$fileval[1].ext");
         while ($readline1 = <READS1> )
                {
                $readcounts1++;
                }
        open(OUT, "<$_-TAcount.wig");
         while ($output = <OUT> )
                {
                chomp ($output);
                @output1 = split ('\t', $output);
                $countgr += $output1[1];
                }
              

print "Total no of TA sites in $fileval[1]  = $count\n";
print "Total no of reads sequenced = $readcounts1\n";
print "Total no of reads mapped to atleast one TA sites = $countgr\n";

$run_time = $end_time - $start_time;
print "Took $run_time seconds\n";
close ANNO;
close READS;
close FILE1;
close READS1;
close OUT;
print "Completed - - - $_\n";

$to = 'vinoy.ramachandran@plants.ox.ac.uk';
$from = 'dops0560@evo.plants.ox.ac.uk';
$subject = "Mapping of $_ completed";
$message = "$_\t$count\t$readcounts1\t$countgr";

open(MAIL, "|/usr/sbin/sendmail -t");

# Email Header
print MAIL "To: $to\n";
print MAIL "From: $from\n";
print MAIL "Subject: $subject\n\n";
# Email Body
print MAIL $message;

close(MAIL);
print "Email Sent Successfully\n";
$pm->finish;
}
}
$pm->wait_all_children;
