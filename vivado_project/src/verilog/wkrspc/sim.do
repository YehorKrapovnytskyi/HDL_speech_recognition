###########################
# Simple modelsim do file #
###########################

# Delete old compilation results
transcript on
if { [file exists work] } {
    vdel -all
}

# Create new modelsim working library

vlib work

# Compile all the Verilog sources in current folder into working library

vlog ../test_models/sv/test_package.sv
vlog ../test_models/c/*.c -dpiheader ../test_models/c/dpiheader.h
vlog ../test_models/sv/*.sv
vlog ../CIC_decimator_HDL_model/*.v





# Open testbench module for simulation

vsim -t 1ns -voptargs=+acc top

# Add all testbench signals to waveform diagram

add wave  /top/*
#add wave  /top/agc_inst0/adder_inst0/*
#add wave  /top/agc_inst0/output_acc_inst0/*

onbreak resume

configure wave -timelineunits us
# Run simulation
run -all

wave zoom full
