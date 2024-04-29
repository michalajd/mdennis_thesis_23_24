#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2023 Advanced Micro Devices, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/home/user/Xylinx/Vitis/2023.1/bin:/home/user/Xylinx/Vivado/2023.1/ids_lite/ISE/bin/lin64:/home/user/Xylinx/Vivado/2023.1/bin
else
  PATH=/home/user/Xylinx/Vitis/2023.1/bin:/home/user/Xylinx/Vivado/2023.1/ids_lite/ISE/bin/lin64:/home/user/Xylinx/Vivado/2023.1/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/mckayla/Desktop/mdennis_thesis_23_24/quickq_v2/quickQ_v2.runs/synth_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

EAStep vivado -log hwpq_test.vds -m64 -product Vivado -mode batch -messageDb vivado.pb -notrace -source hwpq_test.tcl