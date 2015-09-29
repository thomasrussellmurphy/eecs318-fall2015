# Hi, this is something that resembles a makefile
.PHONY: make_work all build1 build2 build3 build4 build5 report clean style

make_work:
	-vlib work

all: | make_work build_all

build_all: build1 build2 build3 build4 build5

build1:
	vlog -novopt q1/*.v

build2:
	vlog -novopt q2/*.v

build3:
	vlog -novopt q3/*.v

build4: build3
	vlog -novopt q4/*.v

build5:
	vlog -novopt q5/*.v

report:
	pdflatex hw1.tex

clean:
	/bin/rm -rf work transcript vsim.wlf */*.*~ *.out *.aux *.pdf *.log

# Settings copied from my style-verilog.sh
style:
	iStyle --indent=spaces=2 --convert-tabs --suffix=".old~" --pad=all */*.v
	echo 'you should probably run `make clean`'
