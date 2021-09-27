UniPlug-FPGA
===========================

体积小、低成本、易用、扩展性强的 FPGA 核心板

![照片](https://github.com/WangXuan95/UniPlug-FPGA/blob/main/用户手册/images/board.png)

![系统框图](https://github.com/WangXuan95/UniPlug-FPGA/blob/main/用户手册/images/diagram.png)



* FPGA型号：Altera Cyclone IV EP4CE6E22 （也兼容 EP4CE10E22）
* 集成 USB-Blaster （PIC18F14K50 单片机方案）
* USB-UART
* 512kB 配置闪存（EPCS4），用于存储 FPGA 配置
* 8MB 用户闪存（W25Q64）SPI-flash
* Micro-SD 卡槽
* 4个用户LED灯
* 三组扩展IO，IOA，IOB，IOC
  * IOA 为固定 3.3V 的 14 个普通 IO
  * IOB 可配置为 24 个普通 IO ，或 6 对 LVDS，电平可用跳线配置为 1.8V、2.5V 或 3.3V 
  * IOC 可配置为 24 个普通 IO ，或 5 对 LVDS，电平可用跳线配置为 1.8V、2.5V 或 3.3V 