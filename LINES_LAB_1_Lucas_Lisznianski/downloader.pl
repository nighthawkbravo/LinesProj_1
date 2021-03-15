#!/usr/bin/perl

use File::Fetch;
use Archive::Tar;

my $url = 'http://d3s3mg9l7h30ko.cloudfront.net/shared/test.tar.gz';
my $ff = File::Fetch->new(uri => $url);
my $file = $ff->fetch() or die $ff->error;

my $tar=Archive::Tar->new();
$tar->read($file);
$tar->extract();
