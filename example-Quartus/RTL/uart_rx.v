module uart_rx #(
    parameter CLK_DIV = 108  // UART baud rate = clk freq/(4*CLK_DIV)
                             // modify CLK_DIV to change the UART baud
                             // for example, when clk=125MHz, CLK_DIV=271, then baud=125MHz/(4*271)=115200
                             // 115200 is a typical baud rate for UART
) (
    input  wire        clk, rst_n,
    // uart rx input
    input  wire        rx,
    // user interface
    output wire        rvalid,
    output wire [7:0]  rdata
);

reg       done = 1'b0;
reg [7:0] data = 8'h0;

reg [31:0] cnt = 0;
reg [ 7:0] databuf = 8'h0;
reg [ 5:0] status=6'h0, shift=6'h0;
reg rxr=1'b1;
wire recvbit = (shift[1]&shift[0]) | (shift[0]&rxr) | (rxr&shift[1]) ;

assign rvalid = done;
assign rdata  = data;

always @ (posedge clk or negedge rst_n)
    if(~rst_n)
        rxr <= 1'b1;
    else
        rxr <= rx;

always @ (posedge clk or negedge rst_n)
    if(~rst_n) begin
        done    <= 1'b0;
        data    <= 8'h0;
        status  <= 6'h0;
        shift   <= 6'h0;
        databuf <= 8'h0;
        cnt      = 0;
    end else begin
        done <= 1'b0;
        cnt   = cnt + 1;
        if( cnt >= CLK_DIV ) begin
            if(status==0) begin
                if(shift == 6'b111_000)
                    status <= 1;
            end else begin
                if(status[5] == 1'b0) begin
                    if(status[1:0] == 2'b11)
                        databuf <= {recvbit, databuf[7:1]};
                    status <= status + 5'b1;
                end else begin
                    if(status<62) begin
                        status <= 62;
                        data <= databuf;
                        done <= 1'b1;
                    end else begin
                        status <= status + 6'd1;
                    end
                end
            end
            shift <= {shift[4:0], rxr};
            cnt = 0;
        end
    end

endmodule