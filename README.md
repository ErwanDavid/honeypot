honeypot
========

Perl honeypot:
Goal is to open a number of tcp (v4) port and to listen to connection.
In parallel, a tcpdump command is launch to track all connection that tries to connect to the port but do not finalise the connection (like nmap scan or invalid tcp packet....)

Need
root privilege (for tcpdump and opening Well Known Port)
mongoDB (for loggin)

Usage example:
 perl ./launcher.pl localhost logdb log_simple log_tcp 2221,2223,2280,28080,22139
