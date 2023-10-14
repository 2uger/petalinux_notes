## Petalinux notes
Petalinux notes i would love to see, when start to work with Xilinx Zynq-7000 Soc.

#### How to create petalinux project:  
* [Follow this](project-creation.md)

#### How to create Vivado peoject:
* Follow this [HDL repo](https://github.com/analogdevicesinc/hdl).  

#### Petalinux project notes:
* If you got and error like below, while building project, you should clean up your project with **petalinux-build -x mrproper**.  
Sometimes it happened when you stop your build unexpectedly, update your XSA file and start build again.
	```
	| ps7_init.c:7867:5: note: (near initialization for 'ps7_post_config_2_0[4]')
	| ps7_init.c:7880:5: error: initializer element is not constant
	|  7880 |     EMIT_WRITE(0XF8898FB0, 0xC5ACCE55U),
	|       |     ^~~~~~~~~~
	| ps7_init.c:7880:5: note: (near initialization for 'ps7_debug_2_0[0]')
	| ps7_init.c:7885:5: error: initializer element is not constant
	|  7885 |     EMIT_WRITE(0XF8899FB0, 0xC5ACCE55U),
	|       |     ^~~~~~~~~~
	``` 

#### Xilinx DMA:
* DMA is the way to communicate between logic and CPU.
	* [This repo](https://github.com/bperez77/xilinx_axidma) contains driver, user library, example applications.  
	* [This wiki](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/1027702787/Linux+DMA+From+User+Space+2.0) describe how to use DMA in Vivado project, give one-file driver and user space application,  
          much easier to read and to understand.  
