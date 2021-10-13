`timescale 1ns/1ns

module FlashW25QXXReadID (
    input  wire        clk,
    // Flash SPI interface
    output reg         spi_ss,
    output reg         spi_sck,
    output reg         spi_mosi,
    input  wire        spi_miso,
    // ID output
    output reg         id_ok,
    output reg  [15:0] id
);

initial spi_ss   = 1'b1;
initial spi_sck  = 1'b0;
initial spi_mosi = 1'b0;

initial id_ok = 1'b0;
initial id = '0;

reg [7:0] cnt = '0;


always @ (posedge clk)
    if(cnt < 8'hff)
        cnt <= cnt + 8'h1;
    else
        id_ok <= 1'b1;

always @ (posedge clk)
    spi_ss <= (cnt < 8'h70 || cnt >= 8'hf0);


always @ (posedge clk)
    if(cnt >= 8'h80 && cnt <= 8'he0) begin
        spi_sck  <= cnt[0];
        spi_mosi <= (cnt == 8'h80 || cnt == 8'h81 || cnt == 8'h86 || cnt == 8'h87);
    end


always @ (posedge clk)
    if(cnt > 8'hc0 && cnt < 8'he0 && cnt[0])
        id <= {id[14:0], spi_miso};


endmodule
