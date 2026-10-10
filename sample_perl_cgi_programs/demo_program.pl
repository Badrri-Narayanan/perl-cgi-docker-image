#!/usr/bin/perl
use strict;
use warnings;
use CGI ();

# SAMPLE_ENV_VAR is set in docker-compose.yml and passed through by apache's PassEnv.
my $sample_env_var = CGI::escapeHTML($ENV{SAMPLE_ENV_VAR} // '(not set)');

print CGI::header(-type => 'text/html', -charset => 'utf-8');
print <<"HTML";
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Hello World - Perl CGI Program</title>
</head>
<body>
    <h2>Hello World! This is my demo CGI program</h2>
    <p>SAMPLE_ENV_VAR = <code>$sample_env_var</code></p>
    <p><a href="/">Back to the form</a></p>
</body>
</html>
HTML
