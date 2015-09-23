# Hi, this is something that resembles a makefile
build1:
	-vlib work
	vlog -novopt q1/*.v

build2:
	-vlib work
	vlog -novopt q2/*.v

clean:
	/bin/rm -rf work transcript vsim.wlf */*.*~

# Settings copied from my style-verilog.sh
style:
	iStyle --indent=spaces=2 --convert-tabs --suffix=".old~" --pad=all */*.v
	echo 'you should probably run `make clean`'
