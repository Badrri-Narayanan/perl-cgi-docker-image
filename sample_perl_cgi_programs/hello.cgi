#!/usr/bin/perl
use strict;
use warnings;
use CGI ();

# Reject oversized bodies instead of reading whatever Content-Length claims.
$CGI::POST_MAX        = 10 * 1024;
$CGI::DISABLE_UPLOADS = 1;

my $q = CGI->new;

if (my $error = $q->cgi_error) {
    print $q->header(-status => $error);
    exit 0;
}

# Everything user-supplied is HTML-escaped before it reaches the page.
my $first_name = CGI::escapeHTML($q->param('first_name') // '');
my $last_name  = CGI::escapeHTML($q->param('last_name')  // '');

print $q->header(-type => 'text/html', -charset => 'utf-8');
print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>The second CGI program</title>
</head>
<body>
    <h1>The power of mod_perl and Apache httpd</h1>
    <p>Hello <strong>$first_name $last_name</strong>. Are you liking mod_perl?</p>
    <p><a href="/">Back to the form</a></p>
</body>
</html>
HTML
