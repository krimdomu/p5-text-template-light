package Text::Template::Light;
use strict;
use warnings;

use vars qw($VERSION);

$VERSION='0.0.1';

sub new {
	my $that = shift;
	my $proto = ref($that) || $that;
	my $self = { @_ };

	bless($self, $proto);

	return $self;
}

sub parse {
	my $self = shift;
	my $data = shift;
	my $vars = shift;

	my $new_data;
	my $r="";

	$new_data = join("\n", map {
		my ($code, $type, $text) = ($_ =~ m/(\<%)*([+])*(.+)%\>/s);

		if($code) {
			$text =~ s/([\$\@\%])::([a-zA-Z0-9_]+)/$1\{\$$2\}/g;
			if($type && $type eq "+") {
				$_ = "\$r .= $text;";
			} else
			{
				$_ = $text;
			}
		} else {
         s/"/\\"/g;
			$_ = '$r .= "' . $_ . '";';
		}

	} split(/(\<%.*?%\>)/s, $data));

	eval {
		no strict 'refs';
		no strict 'vars';

		for my $var (keys %{$vars}) {
			unless(ref($vars->{$var})) {
				$$var = \$vars->{$var};
			} else {
				$$var = $vars->{$var};
			}
		}

		eval($new_data);
	};

	return $r;
}

1;
