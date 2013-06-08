# download vidoop images 
#!/usr/local/bin/perl -w

use WWW::Mechanize;
use HTTP::Headers;

die "Usage: vidoopDownload <url> <outputFolder> <numChallenges>\n" if ($#ARGV < 2);

# read input data
my $url = $ARGV[0]; # url of the challenge        #'http://demo.vidoop.com/captcha/';
my $outputFolder = $ARGV[1]; # name of the output folder where to store the images and requested categories' names           #'D:/perl/images';
my $numChallenges = $ARGV[2]; #number of images to download

my $mech = WWW::Mechanize->new( );

# loop over the number of challenges to be downloaded
for($i=1; $i <= $numChallenges; $i++) {
	
	print "$i\n";
	
	# get the image url, performing this operation within a loop is equivalent to refreshing the webpage
	$mech->get( $url );
	$mech->success or die "Can't get this url $url\n\n";

	# get the html source content of the webpage
	my $res = $mech->content();

	# parse the content looking for the image url
	$res =~ /<img src=\"(\S+):\S+\/vs\/captchas\/(\S+)\/image\"/;
	$file = "$1\/vs\/captchas\/$2\/image\n";
	$download = "$outputFolder\/challenge$i.jpg";
	save_image($file, $download); # save the image in the specified output folder
	
	# parse the content looking for categories requested by the challenge
	$res =~ /enter the letters for: (.+)/;
	@concepts = split(/<span class=\"category_name\">/, $1);
	
	# print the categories' names in the specified output folder
	$outFile = "$outputFolder\/challenge$i.txt";
	open (OUTPUTFILE, ">$outFile");
	print OUTPUTFILE "Categories:\n\n";
	my $check = 0;
	foreach $key (@concepts) {
		$key =~ /(.+)</;
		if($check eq 1) {
			print OUTPUTFILE "$1\n";
		}
		$check = 1;
	}
	close OUTPUTFILE;
}



# SAVE IMAGE------------------------------------------------------------------------------
#
# This script will grab an image from a web page and save it locally
#
# USAGE: save_image($file, $download);
# 
# INPUT: $file = name of the image on the server
#        $download = where the image will be saved locally
#

sub save_image { #copy web FILE to local DOWNLOAD location

my ($file, $download) = @_;

my $user_agent = LWP::UserAgent->new;

my $request = HTTP::Request->new('GET', $file);

my $response = $user_agent->request ($request, $download);

}

