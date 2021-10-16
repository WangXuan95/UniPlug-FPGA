`timescale 1ns/1ns

module top(
    // Clocks
    input  wire           CLK27M,
    // LED
    output wire [ 2:0]    LED,
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
    input  wire [ 3:0]    SD_DAT,
    // CAN
    output wire           CAN_TX,
    input  wire           CAN_RX,
    // USER IO Group A,
    inout       [ 6:0]    IOA,
    // USER IO Group B and C
    inout       [17:0]    IOB, IOC
);

assign IOA = 7'hz;
assign IOB = 18'hz;
assign IOC = 18'hz;

assign CAN_TX = CAN_RX;

reg         rst_n = 1'b0;

wire        rxvalid;
wire [ 7:0] rxdata;

wire [ 2:0] sd_status;

wire        outreq;    // when outreq=1, a byte of file content is read out from outbyte
wire [ 7:0] outbyte;   // a byte of file content

reg  [31:0] cnt;

wire [15:0] flash_id;




// For input and output definitions of this module, see SDFileReader.sv
SDFileReader #(
    .FILE_NAME      ( "example.txt"  ),  // file to read, ignore Upper and Lower Case
                                         // For example, if you want to read a file named HeLLo123.txt in the SD card,
                                         // the parameter here can be hello123.TXT, HELLO123.txt or HEllo123.Txt
                                         
    .CLK_DIV        ( 1              )   // because clk=50MHz, CLK_DIV is set to 1
                                         // see SDFileReader.sv for detail
) sd_file_reader_inst (
    .clk            ( CLK27M         ),
    .rst_n          ( rst_n          ),  // rst_n active low, re-scan and re-read SDcard by reset
    
    // signals connect to SD bus
    .sdclk          ( SD_CLK         ),
    .sdcmd          ( SD_CMD         ),
    .sddat          ( SD_DAT         ),
    
    // display information
    .sdcardstate    (                ),
    .sdcardtype     ( sd_status[1:0] ),  // 0=Unknown, 1=SDv1.1 , 2=SDv2 , 3=SDHCv2
    .fatstate       (                ),  // 3'd6 = DONE
    .filesystemtype (                ),  // 0=Unknown, 1=invalid, 2=FAT16, 3=FAT32
    .file_found     ( sd_status[2]   ),  // 0=file not found, 1=file found
    
    // file content output interface
    .outreq         ( outreq         ),
    .outbyte        ( outbyte        )
);


// send file content to UART
uart_tx #(
    .UART_CLK_DIV   ( 234            ),  // UART baud rate = clk freq/(2*UART_TX_CLK_DIV)
                                         // modify UART_TX_CLK_DIV to change the UART baud
                                         // for example, when clk=50MHz, UART_TX_CLK_DIV=434, then baud=50MHz/(2*434)=115200
                                         // 115200 is a typical SPI baud rate for UART
                                        
    .FIFO_ASIZE     ( 13             ),  // UART TX buffer size=2^FIFO_ASIZE bytes, Set it smaller if your FPGA doesn't have enough BRAM
    .BYTE_WIDTH     ( 1              ),
    .MODE           ( 1              )
) uart_tx_inst (
    .clk            ( CLK27M         ),
    .rst_n          ( rst_n          ),
    
    .wreq           ( outreq         ),
    .wgnt           (                ),
    .wdata          ( outbyte        ),
    
    .o_uart_tx      ( UART_TX        )
);


uart_rx #(
    .CLK_DIV        ( 59             )
) uart_rx_switch (
    .clk            ( CLK27M         ),
    .rst_n          ( 1'b1           ),
    .rx             ( UART_RX        ),
    .rvalid         ( rxvalid        ),
    .rdata          ( rxdata         ) 
);

always @ (posedge CLK27M)
    rst_n <= ~(rxvalid && rxdata=="r");
    


FlashW25QXXReadID flash_read_id (
    .clk            ( CLK27M         ),
    .spi_ss         ( FLASH_CS       ),
    .spi_sck        ( FLASH_SCK      ),
    .spi_mosi       ( FLASH_MOSI     ),
    .spi_miso       ( FLASH_MISO     ),
    .id_ok          (                ),
    .id             ( flash_id       )
);



always @ (posedge CLK27M)
    cnt <= cnt + 1;
    
always_comb 
    casex(cnt[26:24])
    3'b0xx : LED <= cnt[25:23];
    3'b100 : LED <= sd_status;
    3'b101 : LED <= flash_id[2:0];
    3'b110 : LED <= flash_id[5:3];
    3'b111 : LED <= flash_id[8:6];
    endcase

endmodule
