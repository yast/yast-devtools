#! /bin/bash
function mkps ()
{
    dot -Tps -o${1%.dot}.ps $1
}

{
echo "digraph imports {"
# use the first arg, with a default value
find ${1:-/local/home2/yast2-freshdoc.new} -name \*.ycp |xargs ./import.pl
echo "}"
} > import.dot
tred import.dot > import-tr.dot

mkps import.dot
mkps import-tr.dot
