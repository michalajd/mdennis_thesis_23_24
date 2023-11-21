#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2023.1.1 (64-bit)
#
# Filename    : compile.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for compiling the simulation design source files
#
# Generated by Vivado on Tue Nov 21 11:13:03 EST 2023
# SW Build 3900603 on Fri Jun 16 19:30:25 MDT 2023
#
# IP Build 3900379 on Sat Jun 17 05:28:05 MDT 2023
#
# usage: compile.sh
#
# ****************************************************************************
set -Eeuo pipefail
# compile Verilog/System Verilog design sources
echo "xvlog --incr --relax -L uvm -prj coreTest_vlog.prj"
xvlog --incr --relax -L uvm -prj coreTest_vlog.prj 2>&1 | tee compile.log

echo "Waiting for jobs to finish..."
echo "No pending jobs, compilation finished."
