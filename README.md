Petalinux notes i would love to see, when start to work with Xilinx Zynq-7000 Soc.
## Vivado project
Use this [HDL repo](https://github.com/analogdevicesinc/hdl) to create basic skeleton for your project.  
They use TCL scripts to recreate project, so it easy to follow and update your design with TCL scripts, so you  
can recreate your project almost anywhere.
### Petalinux project
* Petalinux based on Yocto, that's mean you can use layers.  
You can create Petalinux project from scratch, but i suggest you to use [Meta-adi repo](https://github.com/analogdevicesinc/meta-adi/blob/master/meta-adi-xilinx/README.md) as start point.  
They already have usefull settings for your Kernel, some DTB's.  
Follow their instruction to build first image.  
Then:
	* Create final blobs:
	**petalinux-package --boot --fsbl --fpga <path to .bit file> --u-boot**  
	* [Format you SD-card](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841655/Prepare+Boot+Medium)
	*  Flash BOOT.bin, image.ub, boot.scr into boot partition.
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
### Xilinx DMA:
* You will definitely need a way to communicate with your Design from CPU.  
	You can use AXI4-lite or AXIS(Stream interace) via DMA.  
	[This repo](https://github.com/bperez77/xilinx_axidma) contains driver, user library, example applications.  
	**HINTS:**
	* If you will realize your own AXIS slave, be carefull with TLAST signal, most of the time we've got an error on driver side  
	   because doesn't setup TLAST signal properly.
