#!/usr/bin/perl

use strict;
use warnings;

use lib '../lib';

use Text::Template::Light;

my $data = q~
<html>
<head>
</head>
<body>
	<h1><%+ $::title %></h1>
	<ul>
		<% for my $i (@::ul) { %>
			<li><%+ $i %></li>
		<% } %>
	</ul>
	<p>name: <%+ $::name %></p>
</body>
</html>
~;

my $t = Text::Template::Light->new();
print $t->parse($data, {
	title => "Hi",
	ul => ['one', 'two', 'three', 'four'],
	name => 'Max'
});

