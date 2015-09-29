onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -format Logic :tb_fsm:clk
add wave -noupdate -format Logic :tb_fsm:x
add wave -noupdate -divider {^^ Stimulus}
add wave -noupdate -format Logic :tb_fsm:z1_b
add wave -noupdate -format Logic :tb_fsm:z2_b
add wave -noupdate -format Logic :tb_fsm:DUT1:y2
add wave -noupdate -format Logic :tb_fsm:DUT1:y1
add wave -noupdate -format Literal :tb_fsm:DUT1:next_state
add wave -noupdate -divider {^^ behavioral}
add wave -noupdate -format Logic :tb_fsm:z1_s
add wave -noupdate -format Logic :tb_fsm:z2_s
add wave -noupdate -format Logic :tb_fsm:DUT2:y1
add wave -noupdate -format Logic :tb_fsm:DUT2:y2
add wave -noupdate -divider {^^ structural}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {277 ns} 0}
configure wave -namecolwidth 186
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {452 ns}
