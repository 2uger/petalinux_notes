Simple serial to AXIS serializer. This module was used with DMA.  
Rare case, but it's just for demonstration.  
Notes:  
* Be carefull with tlast_o signal, if it's not set with the exact size DMA expect, software side will hang.
* Pay attention for ram usage to utilize BRAM resources on your fpga, if you got some. [Check more](https://docs.xilinx.com/r/en-US/ug440-xilinx-power-estimator/Using-the-Block-RAM-BRAM-Sheet).
