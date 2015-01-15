# NAME

Dancer2::Plugin::ApplyRole - Dancer2 plugin to apply a Moo(se) role to an app

# VERSION

version 0.001

# SYNOPSIS

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

# DESCRIPTION

This module implements a plugin to apply Moo(se) roles to your application class.

# AUTHOR

Russell Jenkins <russellj@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2015 by Russell Jenkins.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
