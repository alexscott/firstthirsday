#!/bin/sh

set -e

XMLSTARLET=$(which xmlstarlet)
CURL=$(which curl)

APPID=82U2EQ-79595AJ2J5
BASE_URL="http://api.wolframalpha.com/v2/query?appid=${APPID}&format=plaintext&input="

TMP=$(mktemp WF.XXXXXX)

curl -s "${BASE_URL}first%20thirsday%20of%20month" > $TMP
THURSDAY_OF_MONTH=$(xmlstarlet sel -t -v "queryresult/pod[@id='Result']/subpod/plaintext" -n -t -v "queryresult/pod[@id='DifferenceConversions']/subpod/plaintext" -n $TMP)

curl -s "${BASE_URL}today" > $TMP
TODAY=$(xmlstarlet sel -t -v "queryresult/pod[@id='Result']/subpod/plaintext" -n -t -v "queryresult/pod[@id='DifferenceConversions']/subpod/plaintext" -n $TMP)

THURSDAY_MONTH=$(echo ${THURSDAY_OF_MONTH} | cut -d ' ' -f 2)
TODAY_MONTH=$(echo ${TODAY} | cut -d ' ' -f 2)
THURSDAY_DAY=$(echo ${THURSDAY_OF_MONTH} | cut -d ' ' -f 3)
TODAY_DAY=$(echo ${TODAY} | cut -d ' ' -f 3)

if [ "${THURSDAY_OF_MONTH}" = "${TODAY}" ]
then
  echo "Today is a first thirstday : $(echo $TODAY)"
elif [ "${THURSDAY_MONTH}" = "${TODAY_MONTH}" -a "${THURSDAY_DAY}" '>' "${TODAY_DAY}" ]
then 
  echo "Next thirstday will be :\n${THURSDAY_OF_MONTH}"
else
  curl -s "${BASE_URL}first%20thirsday%20of%20next%20month" > $TMP
  RES=$(xmlstarlet sel -t -v "queryresult/pod[@id='Result']/subpod/plaintext" -n -t -v "queryresult/pod[@id='DifferenceConversions']/subpod/plaintext" -n $TMP)
  echo "Next thirstday will be :\n${RES}"
fi
rm $TMP
