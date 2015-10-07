# Hi, this is something that resembles a makefile
.PHONY: make_work all build1 build2 report clean style

make_work:
	-vlib work

all: | make_work build_all

build_all: build1 build2

build1:
	vlog -novopt q1/*.v

build2:
	vlog -novopt q2/*.v

report:
	pdflatex hw2.tex

clean:
	/bin/rm -rf work transcript vsim.wlf */*.*~ *.out *.aux *.pdf *.log

# Settings copied from my style-verilog.sh
style:
	iStyle --indent=spaces=2 --convert-tabs --suffix=".old~" --pad=all */*.v
	echo 'you should probably run `make clean`'
