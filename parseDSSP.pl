#!/usr/bin/perl -w

#usage: ./parsePDBFile.pl filename 

# given an input (PDB) file, parses it to read and write the H,N,HA and CA coords.


$inputFile         = shift;
if ($inputFile =~ /(.*)\.dssp$/)
#if ($inputFile =~ /(.*)\.coor$/)
{
      $outputFile = $1.".parsedDSSP";
      print STDERR "check out $outputFile\n";
      open (FOUT, ">$outputFile");
}
else
{
    die("error! file should be a dssp file and should finish with .dssp\n");
}

open (FIN, $inputFile) || 
    die ("couldn't open $inputFile (should be the dssp file)");

$start = 0;
$end = 0;
$temp = " ";
while ($line = <FIN>)
{

    if (($line =~ /^[\s+\d+]/))
    {
	
	&parseLine ($line);
    }
}

# the line contains the coordinate info, which will be printed.
sub parseLine 
{
    my $line           = shift;
    if ($line =~ /^\s*\d+\s+(\d+)\s+\w\s+(\w)*/)
#    if ($line =~ /^ATOM\s+\d+\s+(\S+)\s+(\S\S\S)[\+]*[\S\s]\s+(\-*\d+)\s+(\-*\d+\.\d+)\s+(\-*\d+\.\d+)\s+(\-*\d+\.\d+)/)
    {

#	print STDERR "READ LINE = $line\n";
	$RESIDUE                 = $1;
	$STRUCTURE               = $2;

#	$aaNumber              = $aaNumber - 78; #for 1CMZ

#	print STDERR "substracted 78 from the AA number for 1CMZ.\n";
    if ($temp ne $STRUCTURE)
    {
        if (&writeAtom($STRUCTURE))
        {
            if (($temp eq "H")||($temp eq "E")||($temp eq "G")||($temp eq "I"))
            {
                print FOUT "$start $end $temp\n";
            }
            $start = $RESIDUE;
            $temp = $STRUCTURE;
        }
        unless (&writeAtom($STRUCTURE)) 
        {
            if (($temp eq "H")||($temp eq "E")||($temp eq "G")||($temp eq "I"))
            {
                print FOUT "$start $end $temp\n";
            }
            $temp = $STRUCTURE;
        }
    }
    elsif ($temp eq $STRUCTURE)
    {
        $end = $RESIDUE;
    }
    }
}



sub writeAtom
{
    my $STRUCTURE = shift;
    my $retval   = 1;
#   unless (($atomCode eq "H") || ($atomCode eq "N") || ($atomCode eq "CA") || ($atomCode eq "HA")) 
#    unless (($atomCode eq "H"))# || ($atomCode eq "N"))
#    unless (($atomCode eq "CA"))# || ($atomCode eq "N"))
    unless (($STRUCTURE eq "H") || ($STRUCTURE eq "E") || ($STRUCTURE eq "G") || ($STRUCTURE eq "I"))
    {
	$retval = 0;
    }
    $retval;
}









