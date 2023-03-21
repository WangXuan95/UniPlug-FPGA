UniPlug-FPGA
===========================

体积小、低成本、易用、扩展性强的 FPGA 核心板，包含2个规格：

* EP4CE6 版本 (6k LUT, 276kbit BRAM)
* EP4CE22 版本 (22kLUT, 608kbit BRAM)

　

　


# EP4CE6 版本

|  ![成品照片](./EP4CE6/board.png)   |
| :--------------------------------: |
| 图：UniPlug-FPGA (EP4CE6版本) 成品 |

|   ![系统框图](./EP4CE6/diagram.png)    |
| :------------------------------------: |
| 图：UniPlug-FPGA (EP4CE6版本) 系统框图 |

UniPlug-FPGA (EP4CE6版本) 包含：

* FPGA: Altera Cyclone IV EP4CE6E22  (6k LUT, 276kbit BRAM)
* 集成 USB-Blaster (PIC18F14K50 单片机方案)
* 512kB 配置闪存 (EPCS4)，用于存储 FPGA 配置
* 8MB 用户闪存 SPI-flash (W25Q64) 
* USB-UART
* Micro-SD 卡槽
* 4个用户LED灯
* 三组扩展IO，IOA，IOB，IOC
  * IOA 是 14 个普通 IO ， 电平固定为 3.3V
  * IOB 可配置为 24 个普通 IO ，或 6 对 LVDS，电平可用跳线配置为 1.8V、2.5V 或 3.3V 
  * IOC 可配置为 24 个普通 IO ，或 5 对 LVDS，电平可用跳线配置为 1.8V、2.5V 或 3.3V 

### 制造注意事项

1. PCB用立创EDA设计，见： [oshwhub.com/wangxuan/ep4ce6-atom](https://oshwhub.com/wangxuan/ep4ce6-atom)
2. **FPGA芯片下方的散热焊盘必须焊接，否则FPGA无法上传程序**，我留了一个大通孔，方便焊接
3. 需要给 PIC18F14K50 单片机烧写 USB-blaster 固件，见 [PIC18F14K50固件(USB-blaster)制作](#pic18)
4. 制造完成后，烧写 FPGA 时，**需要按照《用户手册.pdf》把 IOB 和 IOC 的电源输入用跳线帽连接到任意电源上！否则 FPGA 将无法上传程序！**
4. **EP4CE6/quartus_prj.zip** 中提供了一个示例 Quartus 程序，用来测试板上的所有外设。

　

　


# EP4CE22 版本

|  ![成品照片](./EP4CE22/board.png)   |
| :---------------------------------: |
| 图：UniPlug-FPGA (EP4CE22版本) 成品 |

|   ![系统框图](./EP4CE22/diagram.png)    |
| :-------------------------------------: |
| 图：UniPlug-FPGA (EP4CE22版本) 系统框图 |

UniPlug-FPGA (EP4CE22版本) 包含：

* FPGA: Altera Cyclone IV EP4CE22E22 (22kLUT, 608kbit BRAM)
* 集成 USB-Blaster (PIC18F14K50 单片机方案)
* 2MB 配置闪存 (EPCS16)，用于存储 FPGA 配置
* 8MB 用户闪存 SPI-flash (W25Q64) 
* USB-UART
* CAN总线PHY (TJA1050)
* Micro-SD 卡槽
* 3个用户LED灯
* 三组扩展IO，IOA，IOB，IOC
  * IOA 是 7 个普通 IO ， 电平固定为 3.3V
  * IOB 可配置为 18 个普通 IO，电平可用跳线配置为 1.8V、2.5V 或 3.3V 
  * IOC 可配置为 18 个普通 IO，电平可用跳线配置为 1.8V、2.5V 或 3.3V 

### 制造注意事项

1. PCB用立创EDA设计，见： [oshwhub.com/wangxuan/ep4ce6-atom_copy](https://oshwhub.com/wangxuan/ep4ce6-atom_copy)
2. **FPGA芯片下方的散热焊盘必须焊接，否则FPGA无法上传程序**，我留了一个大通孔，方便焊接
3. 需要给 PIC18F14K50 单片机烧写 USB-blaster 固件，见 [PIC18F14K50固件(USB-blaster)制作](#pic18)
4. 制造完成后，烧写 FPGA 时，**需要按照《用户手册.pdf》把 IOB 和 IOC 的电源输入用跳线帽连接到任意电源上！否则 FPGA 将无法上传程序！**
4. **EP4CE22/quartus_prj.zip** 中提供了一个示例 Quartus 程序，用来测试板上的所有外设。

　

　


# <span id="pic18">PIC18F14K50固件(USB-blaster)制作</span>

> :pushpin: 该方案来自： http://sa89a.net/mp.cgi/ele/ub.htm?tdsourcetag=s_pctim_aiomsg


PIC18F14K50 芯片是一个单片机，需要给它烧写一个固件，来把它变成一个 USB-blaster 。请按如下步骤操作：


1. 准备一个 PIC8 单片机烧写器，我用的是 PICkit3


2. 按下表把 PICkit3 连接到 PIC18F14K50 芯片，你可能需要自己焊接飞线，或者用芯片烧写座，相信这难不倒熟悉硬件的你 ^_^


| PICkit3 下载器  |  PIC18F14K50   |
| :-------------: | :------------: |
|     1 MCLR      |    4  MCLR     |
| 2 VDD :warning: |     1  VDD     |
|      3 GND      |     20 GND     |
|      4 PGD      |     19 PGD     |
|      5 PGC      |     18 PGC     |
|      6 LVT      | do not connect |

> :warning: 下载器的 VDD 只是输入电压参考，并不提供电压输出，因此应在 VDD 上额外提供 5V，给 PIC18F14K50 供电的同时，也给下载器提供电压参考


3. 下载并安装 [MPLAB v8.91](https://www.microchip.com/en-us/development-tools-tools-and-software/mplab-ecosystem-downloads-archive)


4. 进行如下操作：

    4.1. 解压本文件夹下的 USB-Blaster7.zip

    4.2. 用 MPLAB 打开项目文件 Blaster.mcp

    4.3. 上方 -> Project -> Build Configuration -> Release  (若默认为 Debug 则需要改成 Release)

    4.4. 上方 -> Project -> Build All

    4.5. 电脑通过 USB 连接 PICKit3 下载器，并给 PIC8F14K50 上电

    4.6. 上方 -> Programmer -> Select Programmer -> PICKit 3 

    4.7. 上方 -> Programmer -> Program

    4.8. 上方 -> Programmer -> Verify ，验证烧写是否成功


5. 重新给 PIC8F14K50 上电，连接其 USB ，若能在电脑的“设备管理器”中看见 USB-blaster 设备，说明烧写固件成功。
