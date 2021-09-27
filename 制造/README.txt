
原工程见： https://oshwhub.com/wangxuan/ep4ce6-atom


制造注意事项：

1. 因为没有足够的空间来摆放 Mini USB 下方的定位孔，因此在焊接 Mini USB 母座时，需要把它下面的两个定位的塑料“豆豆”掰掉。

2. 需要给 PIC18F14K50 （单片机）烧写 USB-blaster 固件，见文件夹： PIC18F14K50固件(USB-blaster)

3. 制造完成后，烧写 FPGA 时，需要按照《用户手册.pdf》把 VIOB 和 VIOC 用跳线帽连接到任意电平上，VIOB 和 VIOC 不能悬空，否则 FPGA 将无法成功上传程序。
