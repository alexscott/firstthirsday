#!/bin/bash

set -e

TMP=$(mktemp FT.XXXXXX)

cat > $TMP <<EOF
BEGIN {
  p=0
}

/<table.*calendar/ {
  p=1
}

/<tr.*Monday.*Tuesday/ {
  nr=NR
}

/<\/table/ {
  p=0
}

{
  if(p && NR == nr+1) {
    if(match(\$0, /<td.*<td.*<td><span/))
      print "Aujourd'hui est un premier jeudi du mois"
    else
      print "Aujourd'hui n'est pas un premier jeudi du mois"
  }
}
EOF

curl -s 'http://www.dateaujourdhui.com/' | awk -f $TMP
