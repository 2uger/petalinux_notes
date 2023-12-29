* [Follow this to create basic project](https://github.com/analogdevicesinc/meta-adi/blob/master/meta-adi-xilinx/README.md). 
* Use **zynq** as template for Zedboard.
* Insert this into **project-spec/meta-user/conf/petalinuxbsp.conf**:  
    `KERNEL_DTB="zynq-zed"`
* Create kernel module:  
    `petalinux-create -t modules --name {{RANDOM}} --enable`
* Create test application:  
    `petalinux-create -t apps --name {{RANDOM}} --enable`
* Build project:  
    `petalinux-build`
* Create bootable image:  
    `petalinux-package --boot --fsbl --fpga {{path to the .bit file}} --u-boot`
* [Format SD card](https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/18841655/Prepare+Boot+Medium).  
* Flash **BOOT.bin, image.ub, boot.scr** into **boot** partition.
