@echo off
iverilog -g2005-sv -y ./src/testbench -y ./src -s tb_%1 -o ./testbench/tb_%1  ./src/testbench/tb_%1.sv ./src/*.sv
vvp ./testbench/tb_%1
