
制造注意事项：

1. 工程用立创EDA设计，见： https://oshwhub.com/wangxuan/ep4ce6-atom_copy
2. **FPGA下方的散热焊盘必须焊接，否则FPGA无法上传程序。**（我在对应位置留了一个大通孔，方便焊接）
3. 需要给 PIC18F14K50 （单片机）烧写 USB-blaster 固件，见文件夹： [PIC18F14K50固件(USB-blaster)制作](https://github.com/WangXuan95/UniPlug-FPGA/blob/main/PIC18F14K50固件(USB-blaster)制作)
4. **制造完成后，烧写 FPGA 时，需要按照《用户手册.pdf》把 IOB 和 IOC 的电源输入用跳线帽连接到任意电源上！否则 FPGA 将无法上传程序！**

