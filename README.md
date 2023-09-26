Petalinux notes i would love to see, when start to work with Xilinx Zynq-7000 Soc. <b>
### Vivado project. <t>
Use this [HDL repo](https://github.com/analogdevicesinc/hdl) to create basic skeleton for your project.
They use TCL scripts to recreate project, so it easy to follow and update your design with TCL scripts, so you <t>
can recreate your project almost anywhere.<t>
### Petalinux project:<p>
 - Petalinux based on Yocto, that's mean you can use layers.<t>
You can create Petalinux project from scratch, but i suggest you to use [Meta-adi repo](https://github.com/analogdevicesinc/meta-adi/blob/master/meta-adi-xilinx/README.md) as start point.<t>
They already have usefull settings for your Kernel, some DTB's.<t>
Follow their instruction to build first image.<t>
Then:
	* Create final blobs:
<t> **petalinux-package --boot --fsbl --fpga <path to .bit file> --u-boot**<t>
	* [Format you SD-card](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841655/Prepare+Boot+Medium)
	*  Flash BOOT.bin, image.ub, boot.scr into boot partition.
### Xilinx DMA:
*  You will definitely need a way to communicate with your Design from CPU.<t>
	You can use AXI4-lite or AXIS(Stream interace) via DMA.<t>
	[This repo](https://github.com/bperez77/xilinx_axidma) contains driver, user library, example applications.<t>
	**HINTS:**
	* If you will realize your own AXIS slave, be carefull with TLAST signal, most of the time we've got an error on driver side<t>
	   because doesn't setup TLAST signal properly.
