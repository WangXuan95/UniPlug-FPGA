注： PIC8F14K50 USB-blaster 方案来源：http://sa89a.net/mp.cgi/ele/ub.htm?tdsourcetag=s_pctim_aiomsg




1. 需要准备一个 PIC8 单片机烧写器： 我用的是 PICkit3


2. 下载并安装 MPLAB v8.91
https://www.microchip.com/en-us/development-tools-tools-and-software/mplab-ecosystem-downloads-archive


3. 解压本文件夹下的 USB-Blaster7.zip，用 MPLAB 打开该工程并烧写到 PIC8F14K50。

烧写引脚连接（注，下载器的 VDD 是输入电压参考，并不提供电压输出，因此应在 VDD 上额外提供 5V，给PIC供电的同时，也给下载器提供电压参考）：
-------------------------------------
|  烧写器(PICkit)  |   PIC18F14K50  |
|  1 MCLR          |   4  MCLR      |
|  2 VDD           |   1  VDD       |
|  3 GND           |   20 GND       |
|  4 PGD           |   19 PGD       |
|  5 PGC           |   18 PGC       |
|  6 LVT           |   不连         |
-------------------------------------

MPLAB 单片机烧写流程：
3.1. 用 MPLAB 打开项目文件 Blaster.mcp
3.2. 上方 -> Project -> Build Configuration -> Release （若为 Debug 则改成 Release）
3.3. 上方 -> Project -> Build All
3.4. 电脑通过 USB 连接 PICKit3
3.5. 上方 -> Programmer -> Select Programmer -> PICKit 3 
3.6. 上方 -> Programmer -> Program
3.7. 上方 -> Programmer -> Verify （可以验证烧写是否成功）


4. 完成后，重新给 PIC8F14K50 上电，连接其 USB ，若成功，则能在电脑上看见 USB-blaster 设备
