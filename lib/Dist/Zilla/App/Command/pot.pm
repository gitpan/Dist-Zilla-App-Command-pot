#
# This file is part of Dist-Zilla-App-Command-pot
#
# This software is copyright (c) 2011 by Jerome Quelin.
#
# This is free software; you can redistribute it and/or modify it under
# the same terms as the Perl 5 programming language system itself.
#
use 5.012;
use strict;
use warnings;

package Dist::Zilla::App::Command::pot;
BEGIN {
  $Dist::Zilla::App::Command::pot::VERSION = '1.110340';
}
# ABSTRACT: update i18n messages.pot file with new strings

use Dist::Zilla::App -command;
use File::Temp qw{ tempfile };
use IO::Prompt;
use Moose::Autobox;
use Path::Class;

sub description {
"Update the messages.pot file with new i18n strings found in the
distribution modules.";
}

sub opt_spec {
    my $self = shift;

    return (
        [],
        [ "--potfile|p", "location of the messages.pot to update" ]
    );
}

sub execute {
    my ($self, $opts, $args) = @_;

    my $zilla = $self->zilla;
    $zilla->build;
    my $dist = $self->zilla->distmeta->{name};
    my $copy = $self->zilla->distmeta->{author}->[0];

    # build list of perl modules from where to extract strings
    my @pmfiles =
        grep { $_->name =~ /\.pm$/ }
        grep { $_->isa( "Dist::Zilla::File::OnDisk" ) }
        $zilla->files->flatten;
    my $tmp = File::Temp->new( UNLINK=>1 );
    $tmp->print( map { $_->name . "\n" } @pmfiles );
    $tmp->close;

    # no messages.pot found, prompting user
    if ( not defined $opts->{potfile} ) {
        # try to find existing messages.pot
        $zilla->log( "Trying to find a messages.pot file...");
        ($opts->{potfile}) =
            map  { $_->name }
            grep { $_->name =~ /messages\.pot$/ }
            grep { $_->isa( "Dist::Zilla::File::OnDisk" ) }
            $zilla->files->flatten;
        if ( defined $opts->{potfile} ) {
            $zilla->log( "Found [$opts->{potfile}]" );
        } else {
            $zilla->log( "No messages.pot found - enter your own." );
            my $default = "lib/LocaleData/$dist-messages.pot";
            $opts->{potfile} = prompt( "messages.pot to use: ", -d => $default );
        }
    }

    # update pot file
    unlink $opts->{potfile};
    file($opts->{potfile})->parent->mkpath;
    $zilla->log( "Running xgettext..." );
    system(
        "xgettext",
        "--keyword=T",
        "--from-code=utf-8",
        "--package-name=$dist",
        "--copyright-holder='$copy'",
        "-o", $opts->{potfile},
        "-f", $tmp
    ) == 0 or die "xgettext exited with return code " . ($? >> 8);
}

1;


=pod

=head1 NAME

Dist::Zilla::App::Command::pot - update i18n messages.pot file with new strings

=head1 VERSION

version 1.110340

=head1 SYNOPSIS

    $ dzil pot -p lib/LocaleData/Foo-Bar-messages.pot
    $ dzil pot

=head1 DESCRIPTION

This command will update the messages file used for internationalization
purposes, collecting all the new strings since last invocation.

=head1 SEE ALSO

You can find more information on this module at:

=over 4

=item * Search CPAN

L<http://search.cpan.org/dist/Dist-Zilla-App-Command-pot>

=item * See open / report bugs

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Dist-Zilla-App-Command-pot>

=item * Git repository

L<http://github.com/jquelin/dist-zilla-app-command-pot>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Dist-Zilla-App-Command-pot>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Dist-Zilla-App-Command-pot>

=back

=head1 AUTHOR

  Jerome Quelin <jquelin@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jerome Quelin.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__
