#!/bin/sh
# AMD Live Traffic Report 
# Chris Vidler - Dynatracea DCRUM SME - 2016
# Tested against AMD 12.4 in RTM mode
# Known not to work with NG RTM mode.
#
# Script needs to run with root permissions (or sufficient rights to run rcmd against the RTM process).
#

RCMD=/usr/adlex/rtm/bin/rcmd
AWK=/usr/bin/awk
DATE=/usr/bin/date

echo -e '<?xml version="1.0" encoding="UTF-8"?>'
echo -e '<?xml-stylesheet type="text/xsl" href="xslt.xsl"?>'
echo -e '<amdlive>'

# software service list
echo -e '<dataset id="ss" name="Software Services">'
$RCMD lapp sortby srvbytes descending | $AWK -F'"' '/^\s*$/ {next;} { gsub(/ /,"_",$2) ; print "n:" $2 " a:" $4 "" $5 } ' | $AWK -F' |:' '{ gsub(/_/," ",$2) ; print "<ss><name>"$2"</name><sessions>"$6"</sessions><srvbytes>"$8"</srvbytes><clibytes>"$10"</clibytes></ss>"  }'
echo -e '</dataset>'

# analyzer list
echo -e '<dataset id="anlzr" name="Decodes">'
$RCMD lanlzr sortby srvbytes descending | $AWK -F'"' '/^\s*$/ {next;} { gsub(/ /,"_",$2) ; print "n:"$2 $3} ' | $AWK -F' |:' '{ gsub(/_/," ",$2) ; print "<anlzr><name>"$2"</name><sessions>"$4"</sessions><srvbytes>"$6"</srvbytes><clibytes>"$8"</clibytes></anlzr>"  }'
echo -e '</dataset>'

# server list
echo -e '<dataset id="srv" name="Servers">'
$RCMD lsrv sortby srvbytes descending | $AWK -F' ' '/^\s*$/ {next;} { gsub(/:/,"%3A",$1) } { print "srv:" $1, $2, $3, $4, $5, $6, $7, $8, $9  } ' | $AWK -F':| ' '{ gsub(/%3A/,":",$2); print "<srv><name>"$2"</name><sessions>"$4"</sessions><srvbytes>"$6"</srvbytes><clibytes>"$8"</clibytes></srv>"  }'
echo -e '</dataset>'

# client list
echo -e '<dataset id="cli" name="Clients">'
$RCMD lcli sortby clibytes descending | $AWK -F' ' '/^\s*$/ {next;} { gsub(/:/,"%3A",$1) } { print "cli:" $1, $2, $3, $4, $5, $6, $7, $8, $9  } ' | $AWK -F':| ' '{ gsub(/%3A/,":",$2); print "<cli><name>"$2"</name><sessions>"$4"</sessions><srvbytes>"$6"</srvbytes><clibytes>"$8"</clibytes></cli>"  }'
echo -e '</dataset>'

#session list
echo -e '<dataset id="sess" name="Sessions">'
$RCMD lsess sortby srvbytes descending | $AWK -F'"' ' /^\s*$/ {next;} { x=$2; gsub(/ /,"_",$2) ; print $1 "n:" $2 " a:" $4 "" $5 } ' | $AWK -F' ' '{ gsub(/:/,"%3A",$1); gsub(/:/,"%3A",$2) } { print "srv:"$1,"cli:"$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13 }' | $AWK -F' |:' '{ gsub(/_/," ",$6); gsub(/%3A/,":",$2); gsub(/%3A/,":",$4); print "<sess><name>"$2"</name><client>"$4"</client><ss>"$6"</ss><anlyzr>"$8"</anlyzr><sessions>"$10"</sessions><srvbytes>"$12"</srvbytes><clibytes>"$14"</clibytes></sess>"  }'
echo -e '</dataset>'


# information
echo -e '<info>'
echo -n '<timestamp>'
echo -n `$DATE`
echo -e '</timestamp>'
echo -e '</info>'


echo -e '</amdlive>'

