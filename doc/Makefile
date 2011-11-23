#Makefile for (cs)latex
NAME = main
all: ${NAME}.dvi

# Vyroba PDF primo z DVI by byla prijemnejsi, ale vetsina verzi dvipdfm nici obrazky
# ${NAME}.pdf: ${NAME}.dvi
#	dvipdfm -o $@ -p a4 -r 600 $<
pdf: ${NAME}.pdf

${NAME}.pdf: ${NAME}.ps
	ps2pdf $< $@

${NAME}.ps: ${NAME}.dvi
	dvips -o $@ -D600 -t a4 $<

# LaTeX je potreba spustit dvakrat, aby spravne spocital odkazy
${NAME}.dvi: ${NAME}.tex $(wildcard *.tex) dia
	latex $<
	latex -src $<

#latex prijima pouze eps, je tedy potrebovat zkonvertovat obrazky

# TODO not working properly calling if not necessary
dia: $(wildcard images/*.dia)
# 	dia -t eps -e `echo "$<"|sed s:dia:eps:` $<
clean:
	rm -f *.log  *.dvi *.aux *.toc *.lof *.out ${NAME}.ps ${NAME}.pdf
