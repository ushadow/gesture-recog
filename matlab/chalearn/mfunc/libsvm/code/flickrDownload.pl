#
# Download images for a set of categories
#
#!/usr/local/bin/perl -w
#
use Flickr::API;
use Flickr::API::Request;
use Flickr::API::Response;
use XML::Parser;
use WWW::Mechanize;

die "Usage: flickrDownload <categoryFile.txt> <outputFolder> <numImages>\n" if ($#ARGV < 2);

# read input data
my $categoryFile = $ARGV[0]; # file with the names of the categories to download
my $outputFolder = $ARGV[1]; # name of the output folder where to store the images
my $numImages = $ARGV[2]; # number of images to download


# open the categories file to read the names of the categories
my $i = 0;
my @categoryName = ();
open (INPUTFILE, "$categoryFile");
<INPUTFILE>;
<INPUTFILE>;
while(<INPUTFILE>) {	
	#chomp($categoryName[$i] = $_);
	$categoryName[$i]  = substr($_, 0, length($_)-5);
	$i++;
}
close(INPUTFILE);



# create a new Flickr API instance
my $api = new Flickr::API({'key' => '6791ccf468e1c2276c1ba1e0c41683a4'});

# loop pver category names and download the images
foreach $name (@categoryName) {

	print "downloading the images for $name";
	# create a folder where to store the images, if not yet existing
	mkdir("$outputFolder\/$name");

	# perform the query
	my @data = get_url($name,$numImages);
		
	my $count = 1;
		
	# if the program did not fetch enough images, try to search for similar ones	
	if($#data < $numImages) {	
		if($name =~ /(\S+) and (\S+)/) {
		  
			@data1 = get_url($1,(($numImages-$#data+1)/2));
			@data2 = get_url($2,(($numImages-$#data+1)/2));
			@data = (@data, @data1,@data2);
		}		
		elsif($name =~ /(\S+)s/) {
			
			$newName = $1;			
			if(length($name) eq (length($newName)  +1)) {
				@data1 = get_url($newName,($numImages-$#data));
				@data = (@data, @data1);
			}
			
		}
	}
	
	# download the images
	foreach $key (@data) {
		if($key =~ /(\S+)\" owner=\"(\S+)\" secret=\"(\S+)\" server=\"(\S+)\" farm=\"(\S+)\"/) {
			$url = "http://farm$5.static.flickr.com/$4/$1_$3.jpg";
			$download = "$outputFolder\/$name\/image$count.jpg";
			save_image($url, $download); # save the image in the specified output folder
			$count++;
			print ".";
		}
	}
	print "\n";
}	   
	


# GET URLs------------------------------------------------------------------------------
#
# This script will generate a list of urls of the images for the desired category
#
# USAGE: get_url($name,$numImages);
# 
# INPUT: $name = name of the category to download
#        $numImages = number of images to download (up to 500)
#

sub get_url { 

	my ($name, $numImages) = @_;

	# perform the query
	my $response = $api->execute_method('flickr.photos.search', {
					   'tags' => "$name",
					  # 'sort' => 'relevance',
					   'per_page' => "$numImages",
					});
	my $tmp = ();

	if ($response->is_success) {
	   $tmp = $response->decoded_content;
	}
	else {
		print STDERR $response->status_line, "\n";
	}		
	   
	# parse the return xml data to generate the image urls   
	my @data = split(/<photo id=\"/, $tmp);
	
	return @data;

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
	
	 
 






  
