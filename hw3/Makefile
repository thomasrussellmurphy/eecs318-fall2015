# Hi, this is something that resembles a makefile
.PHONY: work all build1 build2 build3 build4 report clean style

work:
	-vlib work

all: | work build_all

build_all: build1 build2 build3 build4

build1:
	vcom -novopt q1/*.vhd

build2:
	vcom -novopt q2/*.vhd

build3:
	vcom -novopt q3/*.vhd

build4:
	vcom -novopt q4/*.vhd

report:
	pdflatex hw3.tex

clean:
	/bin/rm -rf work transcript vsim.wlf */*.*~ *.out *.aux *.pdf *.log

# Does very little because there's no VHDL formatter I've found
style:
	sed 's/last_compile [0-9]*/last_compile 0/' hw3.mpf >hw3.mpf.temp
	mv hw3.mpf.temp hw3.mpf
