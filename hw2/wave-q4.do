onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic :tb_processor_q4:DUT:clk
add wave -noupdate -format Literal -expand :tb_processor_q4:DUT:mem
add wave -noupdate -format Literal :tb_processor_q4:DUT:processor_registers
add wave -noupdate -format Literal :tb_processor_q4:DUT:program_counter
add wave -noupdate -format Literal :tb_processor_q4:DUT:instruction_register
add wave -noupdate -format Literal :tb_processor_q4:DUT:instruction_opcode
add wave -noupdate -format Literal :tb_processor_q4:DUT:instruction_conditioncode
add wave -noupdate -format Literal :tb_processor_q4:DUT:source_count
add wave -noupdate -format Literal :tb_processor_q4:DUT:destination
add wave -noupdate -format Literal :tb_processor_q4:DUT:processor_sr
add wave -noupdate -format Literal :tb_processor_q4:DUT:result
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3625000 ps} 0}
configure wave -namecolwidth 327
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1954240 ps} {3733990 ps}
