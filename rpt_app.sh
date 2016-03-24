#!/bin/sh

echo -e "<html>"
echo -e "<head>"
echo -e "<title>Software Service Report</title>"
echo -e "<script src='?cmd=get_entry&entry=sorttable.js'></script>"
echo -e "<script>function dosort() { sorttable.innerSortFunction.apply(document.getElementById('sstb'), []); sorttable.innerSortFunction.apply(document.getElementById('srvtb'), []); sorttable.innerSortFunction.apply(document.getElementById('clitb'), []); } </script>"
echo -e "<style>table.sortable th { cursor: pointer; } table.sortable th:not(.sorttable_sorted):not(.sorttable_sorted_reverse):not(.sorttable_nosort):after { content: " \25B4\25BE" }</style>"
echo -e "</head>"
echo -e "<body>"

echo -e "<table class='sortable'>"
echo -e "<tr><th>Software Service</th><th>Sessions</th><th>Server Bytes</th><th>Client Bytes</th><th id='sstb'>Total Bytes</th></tr>"
rcmd lapp | awk -F'"' '/^\s*$/ {next;} { gsub(/ /,"_",$2) ; print "n:" $2 " a:" $4 "" $5 } ' | awk -F' |:' '{ gsub(/_/," ",$2) ; tb=$8 + $10 ; print "<tr><td>"$2"</td><td>"$6"</td><td>"$8"</td><td>"$10"</td><td>"tb"</td></tr>"  }'
echo -e "</table>"

echo -e "<table class='sortable'>"
echo -e "<tr><th>Server</th><th>Sessions</th><th>Server Bytes</th><th>Client Bytes</th><th id='srvtb'>Total Bytes</th></tr>"
rcmd lsrv | awk -F' ' '/^\s*$/ {next;} { gsub(/:/,"%3A",$1) } { print "srv:" $1, $2, $3, $4, $5, $6, $7, $8, $9  } ' | awk -F':| ' '{ gsub(/%3A/,":",$2); tb=$6+$8; print "<tr><td>"$2"</td><td>"$4"</td><td>"$6"</td><td>"$8"</td><td>"tb"</td></tr>"  }'
echo -e "</table>"

echo -e "<table class='sortable'>"
echo -e "<tr><th>Client</th><th>Sessions</th><th>Server Bytes</th><th>Client Bytes</th><th id='clitb'>Total Bytes</th></tr>"
rcmd lcli | awk -F' ' '/^\s*$/ {next;} { gsub(/:/,"%3A",$1) } { print "cli:" $1, $2, $3, $4, $5, $6, $7, $8, $9  } ' | awk -F':| ' '{ gsub(/%3A/,":",$2); tb=$6+$8; print "<tr><td>"$2"</td><td>"$4"</td><td>"$6"</td><td>"$8"</td><td>"tb"</td></tr>"  }'
echo -e "</table>"

echo -e "<p>"
echo `date`
echo -e "</p>"
echo -e "<script>dosort</script>"
echo -e "</body></html>"
