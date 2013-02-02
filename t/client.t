use Test::More 0.88;
use strict; use warnings FATAL => 'all';

use POE;
use POEx::IRC::Backend;

use_ok( 'POEx::IRC::Client::Lite' );

my $got = {};
my $expected = {

};

## FIXME
##  Spawn a fake server
##  Retrieve port
##  Connect client to it
##  Make sure registration looks OK
##  Fake some IRC traffic
##  Shut down

alarm 30;
POE::Session->create(
  package_states => [
    main => [ qw/ 
      _start
      ## FIXME
    / ],
  ],
);
$poe_kernel->run;

sub _start {
  my ($k, $heap) = @_[KERNEL, HEAP];

  $k->sig(ALRM => shutdown => 'timeout');

  $heap->{serv} = POEx::IRC::Backend->new->spawn;
  $k->post( $heap->{serv}->session_id, 'register' );
}

sub shutdown {
  my ($k, $heap) = @_[KERNEL, HEAP];
  ## FIXME shut down client and backend

  fail "Timed out" if $_[ARG0];
}

sub ircsock_registered {
  my ($k, $heap) = @_[KERNEL, HEAP];
  my $backend = $_[ARG0];
  ## FIXME create listener
}

sub ircsock_listener_created {
  my ($k, $heap) = @_[KERNEL, HEAP];
  my $listener = $_[ARG0];

  $heap->{client} = POEx::IRC::Client::Lite->new(
    event_prefix => 'client_',
    server => $listener->addr,
    port   => $listener->port,
    nick   => 'test',
    username => 'user',
  );
  ## FIXME register with client
  $heap->{client}->connect;
}

sub ircsock_listener_open {
  ## FIXME
  ##  Client has connected
}

sub ircsock_input {
  ## FIXME
  ##  See if client is speaking proper IRC
  ##  Make sure we get registration bits
  ##  Talk back to check handlers below
}


## An arbitrary command:
sub client_irc_snack {
  my ($k, $heap) = @_[KERNEL, HEAP];
  ## FIXME
}

## pubmsg parser:
sub client_irc_public_msg {
  my ($k, $heap) = @_[KERNEL, HEAP];
  ## FIXME
}

## ctcp parser:
sub client_irc_ctcp_version {
  my ($k, $heap) = @_[KERNEL, HEAP];
  ## FIXME
}


for my $t (keys %$expected) {
  ok( defined $got->{$t}, "have result for '$t'" );
  cmp_ok( $got->{$t}, '==', $expected->{$t},
    "result for '$t' looks ok"
  );
}

done_testing;
