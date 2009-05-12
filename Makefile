
all: pod html pdf tar upload

pod:
	echo "converting PODs to HTML"
	./mypod2html.pl -d7 -b tt/pod `cat podlist.txt`
	./mypod2html.pl -d7 -b tt/pod -s3 `cat tut.txt`
	./mypod2html.pl -d4 -b tt/pod `cat bins.txt`
	./mypod2html.pl -d7 -b tt/pod `cat index.txt`

html:
	echo "running templates"
	ttree -f tt.conf

pdf:
	echo "converting PODs to PDF"
	cd tex; pod2latex -full -modify -out perlmol.tex `cat pods2.txt`; pslatex perlmol.tex; pslatex perlmol.tex; dvipdf perlmol.dvi; cd ..
	cp tex/perlmol.pdf tt/pod/perlmol.pdf

tar:
	echo "creating tarball"
	tar czf web.tgz htdocs

upload:
	rsync -avz htdocs itubert,perlmol@web.sourceforge.net:
	rsync -avz cgi/ itubert,perlmol@web.sourceforge.net:cgi-bin
