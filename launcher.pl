use strict;

print "Go !\n";

# usage example : launcher.pl localhost logdb log_simple log_tcp 21,22,80,8080,139,445
my ($server, $database, $collection, $collectiontcp, $portlist) = @ARGV;
my @port_list = split(',',$portlist);

# start sockets
foreach (@port_list)
{
        my $cmd = 'perl ./run_honeypot.pl '.$_.' '. $server . ' ' . $database .' '. $collection . " &";
        print "\t - $cmd\n";
        system ($cmd) ;

}

# start tcpdump loging
my $joined = join(' or port ', @port_list);
my $cmd_tcp = "tcpdump -qn 'tcp and port " . $joined . "' | perl ./parser_tcp.pl " . $server . " " . $database . " " . $collectiontcp . " &";
# will issue someting like tcpdump -qn 'tcp and port 22 or port 80' | perl ./parser3.pl &
print "\t - $cmd_tcp\n";
system ($cmd_tcp) ;
print "Done!\nData can take some time to be pushed to the database\n";
