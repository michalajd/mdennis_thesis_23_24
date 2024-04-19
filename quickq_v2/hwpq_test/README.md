# Hardware Test Unit for the HWPQ Project
This module implements a hardware test on a hardware priority queue designed with the HWPQ interface using a Digilent Nexys A7 board.

It is designed to work with 8-bit keys and 8-bit values but can be modified for different bitwidths.

To use the test hardware, you must create (or modifiy) the "wrapper" module in the enclosing directory so that it has separate inputs key_in and value_in and separate outputs k_out and value_out.

Next, create a Vivado project and add the files in this directory to the files of the enclosing HWPQ design (including the constraiints file!)

Once configured on the Nexys board, the test unit performs the following functions:
- BTNL (ENQ): enqueue a single item using switches SW[15:0] to specify an 8-bit key and an 8-bit value.
- BTNR (DEQ): dequeue a single item.
- BTNU (FILL): fill the priority queue using an LFSR to generate a pseudo-random key along with a timestemp in the value field.
- BTND (EMPTY): empty hte priority queue by repeatedly performeing dequeue operations.
- BTNC (RESET)

The FILL and EMPTY operations are performed at a rate specified by the period_enable unit so that their operation can be seen by the human eye.  To operate at full speed, remove the period_enable unit and tie the r_enb signal to 1.

![hwpq_test diagram](doc/hwpq_test.svg)
