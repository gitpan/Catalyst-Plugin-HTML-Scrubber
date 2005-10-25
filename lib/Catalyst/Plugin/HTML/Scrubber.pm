package Catalyst::Plugin::HTML::Scrubber;

use strict;
use base qw/Class::Data::Inheritable/;

use HTML::Scrubber;

our $VERSION = '0.1';

__PACKAGE__->mk_classdata('_scrubber');

sub setup {
    my $c = shift;

    if ($c->config->{scrubber}) {
        my @conf = @{$c->config->{scrubber}};
        $c->_scrubber(HTML::Scrubber->new(@conf));
    } else {
        $c->_scrubber(HTML::Scrubber->new());
    }

    return $c->NEXT::setup(@_);
}

sub prepare_parameters {
    my $c = shift;
    $c->NEXT::prepare_parameters;
    
    for my $value ( values %{ $c->request->{parameters} } ) {
        if ( ref $value && ref $value ne 'ARRAY' ) {
            next;
        }
        
        $_ = $c->_scrubber->scrub($_) for ( ref($value) ? @{$value} : $value );
    }
}

1;
__END__


=head1 NAME

Catalyst::Plugin::HTML::Scrubber - Catalyst plugin for scrubbing/sanitizing html

=head1 SYNOPSIS

    use Catalyst qw[HTML::Scrubber];

    MyApp->config( 
        scrubber => [
            default => 0,
            comment => 0,
            script => 0,
            process => 0,
            allow => [qw [ br hr b a h1]],
        ],
   );

=head1 DESCRIPTION

On request, sanitize HTML tags in all params.

=head1 EXTENDED METHODS

=over 4

=item setup

You can use options of L<HTML::Scrubber>.

=item prepare_parameters

Sanitize HTML tags in all parameters.

=back

=head1 SEE ALSO

L<Catalyst>, L<HTML::Scrubber>.

=head1 AUTHOR

Hideo Kimura, E<lt>hide@hide-k.net<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Hideo Kimura

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
