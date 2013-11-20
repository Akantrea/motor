#!/usr/bin/perl -w

#usage: ./parsePDBFile.pl filename 

# given an input (PDB) file, parses it to read and write the H,N,HA and CA coords.


$inputFile         = shift;
if ($inputFile =~ /(.*)\.upl$/)
#if ($inputFile =~ /(.*)\.coor$/)
{
      $outputFile = $1.".parsedUPL";
      print STDERR "check out $outputFile\n";
      open (FOUT, ">$outputFile");
}
else
{
    die("error! file should be a upl file and should finish with .upl\n");
}

open (FIN, $inputFile) || 
    die ("couldn't open $inputFile (should be the upl file)");


while ($line = <FIN>)
{

    if (($line =~ /^s+/))
    {
	
	&parseLine ($line);
    }
}

# the line contains the coordinate info, which will be printed.
sub parseLine 
{
    my $line           = shift;

    if ($line =~ /^\s+(\d+)\s+\S+\s+\(S+)\s+(\d+)\s+\S+\s+\(S+)\s+\S+\s+\S+\s+\S+\s+\S+\s+\S+$/)
#    if ($line =~ /^ATOM\s+\d+\s+(\S+)\s+(\S\S\S)[\+]*[\S\s]\s+(\-*\d+)\s+(\-*\d+\.\d+)\s+(\-*\d+\.\d+)\s+(\-*\d+\.\d+)/)
    {

#	print STDERR "READ LINE = $line\n";
	$protonNum1              = $1;
	$atomName1               = $2;
	$protonNum2              = $3;
	$atomName2               = $4;

#	$aaNumber              = $aaNumber - 78; #for 1CMZ

#	print STDERR "substracted 78 from the AA number for 1CMZ.\n";


	if (&writeAtom($atomCode1,$atomCode2))
	{
#	    print STDERR "atom code = $atomCode, aa = $aaCode, x = $x, y = $y, z = $z\n";
	    print FOUT "$atomCode1 $atomCode2\n";
	}
 #   elsif ($line =~ /^HETATM\s+\d+\s+(\S+)\s+(\S\S\S)[\s\+][\S\s]\s+(\-*\d+)\s+(\-*\d+\.\d+)\s+(\-*\d+\.\d+)\s+(\-*\d+\.\d+)/) 
 #   {
#	$protonNum1               = $1;
#	$atomName1                = $2;
#	$protobNum2               = $3;
#	$atomName2                = $4;

	
	if (&writeAtom($atomCode1, $atomCode2))
	{
#	    print STDERR "atom code = $atomCode, aa = $aaCode, x = $x, y = $y, z = $z\n";
	    print FOUT "$atomNum1 $atomNum2\n";
	}
    }
# if atom code is "H" or "H1", returns 1, o.w. returns 0;

sub writeAtom
{
    my $atomCode1 = shift;
    my $retval   = 1;
    

#   unless (($atomCode eq "H") || ($atomCode eq "N") || ($atomCode eq "CA") || ($atomCode eq "HA")) 
#    unless (($atomCode eq "H"))# || ($atomCode eq "N"))
#    unless (($atomCode eq "CA"))# || ($atomCode eq "N"))
    unless (($atomCode1 eq "H") || ($atomCode1 eq "HA"))
    {
    	my $atomCode2 = shift;
    	unless (($atomCode1 eq "H") || ($atomCode1 eq "HA"))
    	{
			$retval = 0;
		}
    }
    
    $retval;
}