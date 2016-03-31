#!/bin/sh
# AMD Live Traffic Report 
# Chris Vidler - Dynatracea DCRUM SME - 2016
# Tested against AMD 12.4 in RTM mode
# Known not to work with NG RTM mode.
#
# Script needs to run with root permissions (or sufficient rights to run rcmd against the RTM process).
#

echo -e '<?xml version="1.0" encoding="UTF-8"?>'
echo -e '<?xml-stylesheet type="text/xsl" href="xslt.xsl"?>'
echo -e '<amdlive>'

echo -e '<sslist>'
rcmd lapp sortby srvbytes descending | awk -F'"' '/^\s*$/ {next;} { gsub(/ /,"_",$2) ; print "n:" $2 " a:" $4 "" $5 } ' | awk -F' |:' '{ gsub(/_/," ",$2) ; print "<ss><name>"$2"</name><sessions>"$6"</sessions><srvbytes>"$8"</srvbytes><clibytes>"$10"</clibytes></ss>"  }'
echo -e '</sslist>'


echo -e '<srvlist>'
rcmd lsrv sortby srvbytes descending | awk -F' ' '/^\s*$/ {next;} { gsub(/:/,"%3A",$1) } { print "srv:" $1, $2, $3, $4, $5, $6, $7, $8, $9  } ' | awk -F':| ' '{ gsub(/%3A/,":",$2); print "<srv><name>"$2"</name><sessions>"$4"</sessions><srvbytes>"$6"</srvbytes><clibytes>"$8"</clibytes></srv>"  }'
echo -e '</srvlist>'

echo -e '<clilist>'
rcmd lcli sortby clibytes descending | awk -F' ' '/^\s*$/ {next;} { gsub(/:/,"%3A",$1) } { print "cli:" $1, $2, $3, $4, $5, $6, $7, $8, $9  } ' | awk -F':| ' '{ gsub(/%3A/,":",$2); print "<cli><name>"$2"</name><sessions>"$4"</sessions><srvbytes>"$6"</srvbytes><clibytes>"$8"</clibytes></cli>"  }'
echo -e '</clilist>'

echo -n '<info><timestamp>'
echo -n `date`
echo -e '</timestamp></info>'
echo -e '</amdlive></xml>'


