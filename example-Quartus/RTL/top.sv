module top(
    // Clocks
    input  wire           CLK50M,
    //input  wire           CLK27M,
    // LED
    output wire [ 3:0]    LED,
    // USB-UART
    input  wire           UART_RX,
    output wire           UART_TX,
    // EPCS
    //output wire           EPCS_NCS, EPCS_DCLK, EPCS_ASDO,
    //input  wire           EPCS_DATA0,
    // SPI-Flash
    output wire           FLASH_CS, FLASH_SCK, FLASH_MOSI,
    input  wire           FLASH_MISO, 
    // SD-card
    output wire           SD_CLK,
    inout                 SD_CMD,
    inout       [ 3:0]    SD_DAT,
    // USER IO Group A,
    inout       [13:0]    IOA,
    // USER IO Group B and C
    inout       [23:0]    IOB, IOC
);

assign IOA = 14'hz;
assign IOB = 24'hz;
assign IOC = 24'hz;

reg        rst_n = 1'b0;
wire       rxvalid;
wire [7:0] rxdata;
wire       outreq;    // when outreq=1, a byte of file content is read out from outbyte
wire [7:0] outbyte;   // a byte of file content

reg [31:0] cnt;
wire [3:0] ledval0, ledval1, ledval2;
assign ledval0[2] = outreq;

assign SD_DAT = 4'hz;

// For input and output definitions of this module, see SDFileReader.sv
SDFileReader #(
    .FILE_NAME      ( "example.txt"  ),  // file to read, ignore Upper and Lower Case
                                         // For example, if you want to read a file named HeLLo123.txt in the SD card,
                                         // the parameter here can be hello123.TXT, HELLO123.txt or HEllo123.Txt
                                         
    .CLK_DIV        ( 1              )   // because clk=50MHz, CLK_DIV is set to 1
                                         // see SDFileReader.sv for detail
) sd_file_reader_inst (
    .clk            ( CLK50M         ),
    .rst_n          ( rst_n          ),  // rst_n active low, re-scan and re-read SDcard by reset
    
    // signals connect to SD bus
    .sdclk          ( SD_CLK         ),
    .sdcmd          ( SD_CMD         ),
    .sddat          ( SD_DAT         ),
    
    // display information
    .sdcardstate    (                ),
    .sdcardtype     ( ledval0[1:0]   ),  // 0=Unknown, 1=SDv1.1 , 2=SDv2 , 3=SDHCv2
    .fatstate       (                ),  // 3'd6 = DONE
    .filesystemtype (                ),  // 0=Unknown, 1=invalid, 2=FAT16, 3=FAT32
    .file_found     ( ledval0[3]     ),  // 0=file not found, 1=file found
    
    // file content output interface
    .outreq         ( outreq         ),
    .outbyte        ( outbyte        )
);


// send file content to UART
uart_tx #(
    .UART_CLK_DIV   ( 434            ),  // UART baud rate = clk freq/(2*UART_TX_CLK_DIV)
                                         // modify UART_TX_CLK_DIV to change the UART baud
                                         // for example, when clk=50MHz, UART_TX_CLK_DIV=434, then baud=50MHz/(2*434)=115200
                                         // 115200 is a typical SPI baud rate for UART
                                        
    .FIFO_ASIZE     ( 10             ),  // UART TX buffer size=2^FIFO_ASIZE bytes, Set it smaller if your FPGA doesn't have enough BRAM
    .BYTE_WIDTH     ( 1              ),
    .MODE           ( 1              )
) uart_tx_inst (
    .clk            ( CLK50M         ),
    .rst_n          ( rst_n          ),
    
    .wreq           ( outreq         ),
    .wgnt           (                ),
    .wdata          ( outbyte        ),
    
    .o_uart_tx      ( UART_TX        )
);


uart_rx #(
    .CLK_DIV      ( 108         )
) uart_rx_switch (
    .clk          ( CLK50M      ),
    .rst_n        ( 1'b1        ),
    .rx           ( UART_RX     ),
    .rvalid       ( rxvalid     ),
    .rdata        ( rxdata      ) 
);

always @ (posedge CLK50M)
    rst_n <= ~(rxvalid && rxdata=="r");
    



W25QXX_Read_ID (
    .sys_clk      ( CLK50M             ),
    .sys_rst_n    ( 1'b1               ),
    .W25X16_CS    ( FLASH_CS           ),
    .W25X16_CLK   ( FLASH_SCK          ),
    .W25X16_DIO   ( FLASH_MOSI         ),
    .W25X16_DO    ( FLASH_MISO         ),
    .LED          ( {ledval1, ledval2} )
);

always @ (posedge CLK50M)
    cnt <= cnt+1;
    
always_comb 
    case(cnt[27:26])
    2'b00 : LED <= cnt[25:22];
    2'b01 : LED <= ledval0;
    2'b10 : LED <= ledval1;
    2'b11 : LED <= ledval2;
    endcase

endmodule
