#!/usr/bin/perl
# mypod2html.pl [options] files...
# options: 
# -d <depth>   delete the first <depth> path levels 
# -s <n>       use menu section <n> for the template
# -b <base>    root path to create directories

use strict;
use warnings;
use File::Path;
use Getopt::Std;
use lib '/home/ivan/devel/Pod-HtmlEasy';
use Pod::HtmlEasy;

my %opts;
getopts("d:s:b:", \%opts);

my $podhtml = Pod::HtmlEasy->new(
    on_L  => sub {
        my ( $this , $L , $text, $page , $section, $type ) = @_ ;
        if ( $type eq 'pod' ) {
            $section = defined $section ? "#$section" : '';
            return "<i><a href='/cgi-bin/perldoc?$page$section'>$text</a></i>" ;
        } elsif( $type eq 'man' ) { 
            return "<i>$text</i>" ;
        } elsif( $type eq 'url' ) { 
            return "<a href='$page'>$text</a>" ;
        }
      } ,
);


for my $file (@ARGV) {

    my $name = $podhtml->pm_name($file);

    my $section = $opts{s} ? "section=$opts{s}" : "";
    my $base    = $opts{b} || '.';
    my $head = <<TT;
[% PROCESS head title="$name" %]
[% INCLUDE nav.html $section %]
<div class="main">
TT
    my $foot = "</div></body></html>\n";

    my @path = split '/', $file;

    splice @path, 0, $opts{d} || 0;
    my $path = join "/", @path;

    $path =~ s/\.(pm|pod)//;
    $path .= ".html";
    my ($dir) = $path =~ m|^(.*)/|;
    $dir ||= '';
    $dir = "$base/$dir";
    print "$path\n";
    mkpath($dir);

    my $html = $podhtml->pod2html( $file, undef,
        body => '', 
        title => "PerlMol Doc - $name",
        no_index => 1,
        only_content => 1,
        basic_entities => 1,
    );

    #print "$base/$path";
    open F, ">$base/$path" or die;
    print F $head, $html, $foot;
    close F;
}
