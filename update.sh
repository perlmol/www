#!/bin/bash

echo "converting PODs to HTML"
./mypod2html.pl -d6 -b tt/pod `cat podlist.txt`
./mypod2html.pl -d6 -b tt/pod -s3 `cat tut.txt`
./mypod2html.pl -d3 -b tt/pod `cat bins.txt`
./mypod2html.pl -d6 -b tt/pod `cat index.txt`

echo "converting PODs to PDF"
cd tex
pod2latex -full -modify -out perlmol.tex `cat pods2.txt`
pslatex perlmol.tex
pslatex perlmol.tex
dvipdf perlmol.dvi
cd ..
cp tex/perlmol.pdf tt/pod/perlmol.pdf

echo "running templates"
ttree -f tt.conf

echo "creating tarball"
tar czf web.tgz htdocs
echo "copying tarball"
scp web.tgz shell.sf.net:perlmol
echo "installing tarball"
ssh shell.sf.net 'cd perlmol && tar xvzf web.tgz'
echo installing CGIs
scp cgi/* shell.sf.net:perlmol/cgi-bin

echo "done"
