#!/bin/bash
# BASH script to parse amddata files producing a XML format suitable for XSLT processing elsewhere
# Chris Vidler - Dynatrace DC RUM SME 2016


# --- Config ---
# DEBUG: output extra info for debugging this script not needed for general operation.
DEBUG=1

# WANTED array: Record types we're interested in (others are discarded), saves on output size/processing time etc. 
#  changing these doesn't mean more data on the page, the XSLT would need to be modified to suit.
declare -A WANTED=( [IFC]= [CPU]= [U]= )

# FILETYPES: which file name filters will contain the above wanted record types.
FILETYPES=zdata_*_t_vol,amddata_*_t_rtm

# DSNAMES array: friendly names for the data set types
declare -A DSNAMES=( [rtm]="AMD Statistics" [vol]="Sessions")

# HISTORY: number of seconds to process back from 'now'.
HISTORY=3600



# --- Script follows ---


function debugecho {
        if [ $DEBUG -ne 0 ]; then echo -e "<!-- DEBUG: $@ -->"; fi
}


AWK=`which awk`
IFS=,

echo "<amddata>"
echo "<info><timestamp>"`date`"</timestamp></info>"

set -f
for FILETYPE in $FILETYPES; do
	debugecho "File filter: $FILETYPE"
	DEFNDONE=0

	dataset=`echo $FILETYPE | $AWK 'match($0, /.+_(.+)$/, ary) {print ary[1]}' `
	echo "<dataset id=\"$dataset\" name=\"${DSNAMES[$dataset]}\">"

	set +f
	for FILE in $FILETYPE; do
		debugecho "Processing file: $FILE"

		UTS=`echo $FILE | $AWK -F"_" ' { print strtonum("0x"$2); }'`
		UTS=$(($UTS+$HISTORY))
	
		TIMESTAMP=`echo $FILE | $AWK -F"_" ' { print strftime("%F %T",strtonum("0x"$2),1); }'`
		if [ $UTS -gt `date -u +%s` ]; then 
			debugecho "Timestamp more than ${HISTORY}s old skipping"
			TIMESTAMP=
		fi
		debugecho "Timestamp: $TIMESTAMP"

		if [ $DEFNDONE -ne 1 ]; then
			debugecho "Reading record definitions from: $FILE"
			# process out field definitions from first file
			DEFN=`$AWK -F"=" '$1 ~ /^#Fields:/ { gsub(/:[a-z]+/,"",$2); print $2 }' "$FILE" | $AWK -F" " ' { printf ("%s", $1); for(i=2;i<=NF;i++){printf ",%s", $i} ; printf  "\n"; } '`
			DEFNDONE=1

			declare -A DEFNS
			IFS=,
			while IFS=" " read a b; do
				if [ ${WANTED[$a]+_} ]; then
					DEFNS[$a]=$b
					debugecho "Record type: $a (${DEFNS[$a]})"
				fi
			done < <(echo $DEFN)
		fi

		# process a single sample (file)
		if [ -n "$TIMESTAMP" ]; then
			while IFS=" " read rtype rdata; do
				if [ ${DEFNS[$rtype]+_} ]; then
					# process a single record
					echo -n "<"$rtype" ts=\""$TIMESTAMP"\""
					IFS=", "
					read -a data <<< "$rdata"
					read -a types <<< "${DEFNS[$rtype]}"
					total=${#data[*]}
					for (( i=0; i<=$(( $total -1 )); i++ )) ; do
						echo -n " ${types[$i]}=\"${data[$i]}\""
					done
					echo " />"
				fi
			done < "$FILE"
		fi

		#exit 1
	done

	echo "</dataset>"
	set -f
done

echo "</amddata>"

