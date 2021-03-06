#!/bin/sh

# Run this periodically to ensure that the manpage links are up to date

echo "# This is an auto-generated file by $0" > links
sudo makewhatis
for i in `ls -1 *.3`; do
  name=`echo $i|cut -d. -f1`
  links=`sqlite3 /usr/share/man/mandoc.db \
    "select names.name from mlinks,names where mlinks.name='$name' and mlinks.pageid=names.pageid;"`
  for j in $links; do
    if [ "x$j" != "x$name" ]; then
      echo $name.3,$j.3 >> links
    fi
  done
done
