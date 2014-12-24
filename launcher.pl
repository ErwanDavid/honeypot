my @port_list = ('2221', '2222', '2223', '2280', '28080', '22139', '22445');

print "Lanceur !\n";

foreach (@port_list)
{
        my $cmd = 'perl ./run_honeypot.pl '.$_.' localhost hihoney  Coll_1209 &';
        print "\t - $cmd\n";
        system ($cmd) ;

}

my $joined = join(' or port ', @port_list);

my $cmd_tcp = "tcpdump -qn 'tcp and port " . $joined . "' | perl ./parser_tcp.pl  &";                                                                                                                                               
#tcpdump -qn 'tcp and port not 22 and port not 445 and port not 27017' | perl ./parser3.pl &                                                                                                                                     
print "- $cmd_tcp\n";                                                                                                                                                                                                            
                                                                                                                                                                                                                                 
system ($cmd_tcp) ;                                                                                                                                                                                                              
                                                                                                                                                                                                                                 
print "Done!\n";               
