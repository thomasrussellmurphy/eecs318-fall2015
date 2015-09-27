# Hi, this is something that resembles a makefile
all:
	make build1
	make build2
	make build3
	make build4
	make build5

build1:
	-vlib work
	vlog -novopt q1/*.v

build2:
	-vlib work
	vlog -novopt q2/*.v

build3:
	-vlib work
	vlog -novopt q3/*.v

build4:
	-vlib work
	vlog -novopt q4/*.v

build5:
	-vlib work
	vlog -novopt q5/*.v

report:
	pdflatex hw1.tex

clean:
	/bin/rm -rf work transcript vsim.wlf */*.*~

# Settings copied from my style-verilog.sh
style:
	iStyle --indent=spaces=2 --convert-tabs --suffix=".old~" --pad=all */*.v
	echo 'you should probably run `make clean`'
