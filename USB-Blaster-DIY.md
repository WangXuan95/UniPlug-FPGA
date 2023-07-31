# PIC18F14K50固件(USB-blaster)制作

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
