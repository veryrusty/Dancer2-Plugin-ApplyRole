package Dancer2::Plugin::ApplyRole;

# ABSTRACT: Dancer2 plugin to apply a Moo(se) role to an app

use Dancer2::Plugin;
use Moo::Role;

# VERSION

register 'apply_role' => sub {
    my ($dsl, $role, $args) = plugin_args(@_);

    Moo::Role->apply_roles_to_object($dsl->app, $role);
    ref $args eq 'HASH' or return;

    for my $kw ( @{ $args->{handles} } ) {
        if ( ref $kw eq 'HASH' ) {
            my ($from, $to) = %$kw;
            _handles_keyword($dsl, $from, $to);
        }
        else {
            _handles_keyword($dsl, $kw);
        }
    }
};

sub _handles_keyword {
    my ( $dsl, $from, $to ) = @_;
    $to = $from if ! defined $to;

	# We are wrapped, twice.
    my $caller = caller(2);

    no strict 'refs';
    my $existing = *{"${caller}::${to}"}{CODE};
    next if defined $existing;

    $dsl->register($to, 1);
    *{"${caller}::${to}"} = sub { $dsl->app->$from(@_) };
}

register_plugin;

1;

__END__

=encoding utf-8

=head1 SYNOPSIS

    package MyDancerApp;
    use Dancer2;
    use Dancer2::Plugin::ApplyRole;

    apply_role 'Some::Role';

    get '/' => sub {
        my $app = shift;
        return $app->method_from_some_role;
    };


    package MyOtherDancerApp;
    use Dancer2;
    use Dancer2::Plugin::ApplyRole;

    BEGIN {
        apply_role 'Some::Other::Role' => { handles => ['foo', 'bar' ] }
    }

    foo($some,$params);  # Imported into namespace. Calls $app->foo(...).

=head1 DESCRIPTION

This module implements a plugin to apply Moo(se) roles to your application class.

=cut

