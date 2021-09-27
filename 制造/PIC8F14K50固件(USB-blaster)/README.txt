注： PIC8F14K50 USB-blaster 方案来源：http://sa89a.net/mp.cgi/ele/ub.htm?tdsourcetag=s_pctim_aiomsg



1. 下载并安装 MPLAB v8.91 ：
https://www.microchip.com/en-us/development-tools-tools-and-software/mplab-ecosystem-downloads-archive

2. 需要准备一个 PIC8 单片机烧写器： 我用的是 PICkit 3

3. 解压本文件夹下的 USB-Blaster7.zip，用 MPLAB 打开该工程，并烧写到 PIC8F14K50。

4. 完成后，重新给 PIC8F14K50 上电，连接其 USB ，若成功，则能在电脑上看见 USB-blaster 设备



烧写引脚连接：

烧写器(PICkit)      PIC18F14K50
1 MCLR              4  MCLR
2 VDD               1  VDD
3 GND               20 GND
4 PGD               19 PGD
5 PGC               18 PGC
6 LVT               不连

注，下载器的 VDD 是输入电压参考，并不提供电压输出，因此应在 VDD 上额外提供 5V，给PIC供电的同时，也给下载器提供电压参考。
