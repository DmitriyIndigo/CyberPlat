package CyberPlat;

use strict;
use warnings FATAL => 'all';
use utf8;
use open qw(:std utf8);
use Data::Dumper;
use base 'CGI::Application';
use CGI::Application::Plugin::TT;

use CGI::Application::Plugin::DBH qw(dbh_config dbh dbh_default_name);

use CGI::Session::Driver::mysql;

use CGI::Application::Plugin::Config::Simple;
use CGI::Application::Plugin::Session;
use CGI::Application::Plugin::Authentication;
use CGI::Application::Plugin::Forward;

use lib::abs;
<<<<<<< HEAD
use Email::Valid::Loose;
=======
>>>>>>> 90566144e5bc523e26b64b901bcf97f7d0b68031

sub setup {
    my $self = shift;

    $self->mode_param('step');
    $self->start_mode('on_start');
    $self->run_modes(
        on_start  => \&start,
        on_logout => \&logout,
        on_login  => \&login,
        on_list   => \&list,
        AUTOLOAD  => sub {return 'Page not exist'}
    );
}

sub cgiapp_init {
    my $self = shift;

    $self->config_file('CyberPlat.conf');

    $self->header_add(-Content_Type => 'text/html; charset=UTF-8');

    $self->tt_config(
        TEMPLATE_OPTIONS => {
            COMPILE_DIR => '/tmp',
            WRAPPER     => 'page.tt2',
        }
    );

    my $path = lib::abs::path('..');
<<<<<<< HEAD
=======

>>>>>>> 90566144e5bc523e26b64b901bcf97f7d0b68031
    $self->tt_include_path(["$path/templates"]);

    $self->dbh_config(
        "DBI:mysql:database=" . $self->config_param('database') . ";host=" . $self->config_param('host'),
        $self->config_param('user'),
        $self->config_param('password')
    );

    $self->session_config(
        CGI_SESSION_OPTIONS => ["driver:mysql", $self->query, {Handle => $self->dbh}],
        DEFAULT_EXPIRY      => '+1w',
        COOKIE_PARAMS       => {
            -expires => '+24h',
            -path    => '/',
        },
        SEND_COOKIE => 1,
    );

    $self->authen->config(
        DRIVER => [
            'DBI',
            TABLE       => 'Users',
            CONSTRAINTS => {
                'name'  => '__CREDENTIAL_1__',
                'email' => '__CREDENTIAL_2__',
            },
        ],
        STORE          => 'Session',
        LOGOUT_RUNMODE => 'on_logout',
        LOGIN_RUNMODE  => 'on_login',
        CREDENTIALS    => ['name', 'email'],
    );

    $self->authen->protected_runmodes('on_list',);

}

sub start {
    my ($self) = @_;

    my $user = $self->authen->username;

    if (defined($user)) {
        return $self->forward('on_list');
    }

    return $self->tt_process('login.tt2',);
}

sub list {
    my $self = shift;

    my $q = $self->query();

    my $field = $q->param('field') // 'name';
    my $order = $q->param('order') // 'asc';

    my @errors = ();

    my %fields = map {$_ => 1} qw(name email create_time);
    push(@errors, sprintf('Invalid param "field": %s', $field)) unless $fields{$field};

    my %orders = map {$_ => 1} qw(asc desc);
    push(@errors, sprintf('Invalid param "order": %s', $order)) unless $orders{$order};

    if (@errors) {
        return $self->tt_process('list.tt2', {errors => \@errors});
    }

    my $sth = $self->dbh->prepare("select * from Users order by $field $order");
    $sth->execute();

    my $data = $sth->fetchall_arrayref({});

    return $self->tt_process('list.tt2', {users => $data, cur_field => $field, cur_order => $order});
}

sub login {
    my $self = shift;

<<<<<<< HEAD
    return $self->forward('on_list') if defined($self->authen->username);
=======
    if (defined($self->authen->username)) {
        $self->authen->logout;
        $self->session_delete;
    }
>>>>>>> 90566144e5bc523e26b64b901bcf97f7d0b68031

    my $q = $self->query();

    my %params = ();
    my @missing_params =
      grep {my $v = $params{$_} = $q->param($_); !defined($v) || length($v) == 0} qw(name email);

<<<<<<< HEAD
    return $self->tt_process('login.tt2',
        {error => sprintf('Missing required params: %s', join(', ', @missing_params))})
      if @missing_params;
=======
    if (defined($self->authen->username)) {
        return $self->forward('on_list');
    } else {
        my $q           = $self->query();
        my $email_param = $q->param('email');
>>>>>>> 90566144e5bc523e26b64b901bcf97f7d0b68031

    push(my @warn, 'name') unless $params{'name'} =~ m/^\w{1,15}\z/;
    push(@warn, 'email') unless Email::Valid::Loose->address($params{'email'});

    return $self->tt_process('login.tt2',
        {error => sprintf('Invalid characters: %s ', join(', ', @warn))})
       if @warn;

    my $sth = $self->dbh->prepare('select name from Users where email = ?');
    $sth->execute($params{'email'});

    my $name = $sth->fetchrow_arrayref();

    if (defined($name->[0])) {
        return $self->tt_process('login.tt2', {error => 'Invalid name or email'});
    } else {
        my $sth = $self->dbh->prepare('Insert into Users(name, email) values (?,?)');
        $sth->execute(@params{qw(name email)});

        delete($self->authen->{'initialized'});
        $self->authen->initialize();

        return $self->forward('on_list');
    }
}

sub logout {
    my $self = shift;

    if (defined($self->authen->username)) {
        $self->authen->logout;
        $self->session_delete;
    }

    return $self->forward('on_start');
}

1;
