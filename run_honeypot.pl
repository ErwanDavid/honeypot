#!/usr/bin/perl

# socket copied from
# 8 April 2014
# http://www.glitchwrks.com/
# shouts to binrev

use strict;
use warnings;
use IO::Socket;
use MongoDB;
use DateTime;

   

my $port        = $ARGV[0];
my $mongosrv    = $ARGV[1];
my $mongobase   = $ARGV[2];
my $mongocollec = $ARGV[3];



print "Hi honey on $port\n";
print "Will repport to $mongosrv $mongobase $mongocollec\n";

my $sock = new IO::Socket::INET (
                                  LocalPort => $port,
                                  Proto => 'tcp',
                                  Listen => 1,
                                  Reuse => 1,
                                );

die "Could not create socket!" unless $sock;

my $client        = MongoDB::Connection->new(host => $mongosrv, port => 27017);
my $database_mg   = $client->get_database( $mongobase );
my $collect       = $database_mg->get_collection( $mongocollec );

# The "done" bit of the handshake response
my $done = pack ("H*", '16030100010E');

# Your message here
my $taunt = "09809*)(*)(76&^%&(*&^7657332         This is it!";
my $troll = pack ("H*", ('180301' . sprintf( "%04x", length($taunt))));

# main "barf responses into the socket" loop
while (my $client= $sock->accept()) {
  $client->autoflush(1);

 
  my $found = 0;
  my $client_addr = $client->peeraddr();
  #my ($cDomain, $cPort, $cHost) = unpack('S n a4 x8', $client_addr);
  my $client_ip = join('.',unpack('C4', $client_addr));
  
  $collect->insert({"Po" => $port, "Ip"=> $client_ip,"T"=> '{i}', "D" => $now});


  # read things that look like lines, puke nonsense heartbeat responses until
  # a line that looks like it's from the PoC shows up
  while (<$client>) {
    #my $line = unpack("H*", $_);
    chomp();
    my $line = $_;
    $line =~ s/\W/_/g;
    my $now = DateTime->now;
    #print "GET $client_ip >$line<\n";
    $collect->insert({"Po" => $port, "Ip"=> $client_ip,"T"=> $line, "D" => $now});


    print $client $troll;
    print $client $taunt;
   
  }  
}

close($sock);
