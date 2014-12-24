#!/usr/bin/perl                                                                                                                                                                                                                  
                                                                                                                                                                                                                                 
use strict;                                                                                                                                                                                                                      
use MongoDB;                                                                                                                                                                                                                     
use MongoDB::OID;                                                                                                                                                                                                                
use DateTime;


# use tcp command
#  tcpdump -n host|net not <your client or local net>
#  tcpdump -qn host not 192.168.1.3 and 'tcp'
#00:57:34.153046 IP 192.168.1.2.50802 > 173.194.45.33.443: tcp 0
#00:57:34.153052 IP 173.194.45.33.443 > 192.168.1.2.50802: tcp 1350
#00:57:34.153057 IP 192.168.1.2.50802 > 173.194.45.33.443: tcp 0


# DB
# CONFIG VARIABLES
my $client              = MongoDB::Connection->new(host => 'localhost', port => 27017);
my $database_mg         = $client->get_database( 'hihoney' );
my $logip                       = $database_mg->get_collection( 'tcpd_20141212' );


my $logfile = './LOG.txt';


$| = 1;


my $debug = 3;

my $var;
while ($var = <STDIN>)
{
        if ($var =~ /^(.*)\s+IP\s+(\d+\.\d+\.\d+\.\d+)\.(\d+)\s+>\s+(\d+\.\d+\.\d+\.\d+)\.(\d+)/)
        {
                my $date =$1;
                my $ip1 = $2;
                my $p1  = $3;
                my $ip2 = $4;
                my $p2  = $5;
                #&Log("$date;$ip1;$p1;$ip2;$p2",2);
                $logip->insert({"is" => $ip1, "ps" => $p1,"id" => $ip2,"pd" => $p2,"da" => $date, date => DateTime->now});


        }

}

sub Log
{
        my $mess = shift;
        my $level = shift;



        if ($level <= $debug)
        {
                        my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
                        $mon = sprintf "%.2d",$mon+1;
                        $mday = sprintf "%.2d",$mday;
                        $hour = sprintf "%.2d",$hour;
                        $min = sprintf "%.2d",$min;
                        $sec = sprintf "%.2d",$sec;
                        $mday = sprintf "%.2d",$mday+1;
                        my $date = $mon.'-'.$mday.'-'.$hour.':'.$min.':'.$sec;
                print LOG "[$date]$mess\n";
        }
        close(LOG);


}
