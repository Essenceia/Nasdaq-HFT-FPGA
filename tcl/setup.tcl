#use checkpoints
set checkpoints 1
set ooc 1

if { $argc > 0 } {
	puts $argv
	set device $argv
} else {
	set device "xc7a100tfgg484-2"
}
puts "device $device"

set rtl_path "../"
set xdc_path ""
set build_path "../build"
set project_name hft_fpga
set path ${build_path}/${device}_${project_name}
set log_path $path
set design hft
create_project $project_name $path -part $device -force 
set_property design_mode RTL [current_fileset -srcset]
set top_module $design
set_property top $top_module [get_property srcset [current_run]] 
# add files
read_verilog -sv $rtl_path/top.v

# mold 
read_verilog -sv $rtl_path/moldudp64/cnt_ones_thermo.v
read_verilog -sv $rtl_path/moldudp64/countdown.v
read_verilog -sv $rtl_path/moldudp64/endian_flip.v
read_verilog -sv $rtl_path/moldudp64/header.v
read_verilog -sv $rtl_path/moldudp64/len_to_mask.v
read_verilog -sv $rtl_path/moldudp64/miss_msg_det.v
read_verilog -sv $rtl_path/moldudp64/moldudp64.v

#itch
read_verilog -sv $rtl_path/itch/tv_itch5.v

#add xdc constraints
read_xdc ${device}_ooc.xdc

# synthesis out of context ip
synth_design -mode out_of_context > ${log_path}/${project_name}_synth.rds
#write_checkpoint ${project_name}_synth.dcp

# optimize
opt_design > ${log_path}/${project_name}_opt.rds

# place
place_design > ${log_path}/${project_name}_place.rds

# route
route_design > ${log_path}/${project_name}_route.rds

# write checkpoint

# report utilization
report_utilization -file ${log_path}/${project_name}_utilization.rpt

# timming report
report_timing_summary -file ${log_path}/${project_name}_timing_summary.rpt


close_project



