
module W25QXX_Read_ID ( 
    // clock and reset signal
    input                 sys_clk    ,
    input                 sys_rst_n  ,
    // Flash signal
    output  reg           W25X16_CS  ,
    output  reg           W25X16_CLK ,
    output  reg           W25X16_DIO ,
    input                 W25X16_DO  ,
    // ID LED
    output  reg  [7:0]    LED	  
);

//reg define 
reg     [5:0]         counter       ;

reg     [5:0]         clk_cnt       ;

reg     [15:0]			 shift_buf     ;

//wire define 
wire					    div_clk1		   ;
wire					    div_clk2		   ;

/*******************************************************************************************************
**                              Main Program    
**  
********************************************************************************************************/
//creat a clock about 1MHz
always @(posedge sys_clk or negedge sys_rst_n) begin 
    if  ( sys_rst_n ==1'b0 )  
           clk_cnt <= 6'b0;
    else
           clk_cnt <= clk_cnt + 1'b1;  
end

assign div_clk1 = clk_cnt[5];
assign div_clk2 = ~clk_cnt[5];

//get a counter that width is 6 bits 
always @(posedge div_clk1 or negedge sys_rst_n) begin 
    if  ( sys_rst_n ==1'b0 )  
           counter <= 6'b0;    
    else 
           counter <= counter + 6'b1;
end

//get the enable signal of the w25x16,and the low level effectively			 			 
always @(*)  begin
	 if  ( counter >= 8 && counter <= 58 )  
           W25X16_CS <= 1'b0; 
	 else
		     W25X16_CS <= 1'b1;
end

//get the clock of the w25x16	 
always @(*)  begin
    if  ( counter >= 9 && counter <= 56 )  //the effective clock cycle
           W25X16_CLK <= div_clk1;    //select zhe div_clk1 as the clock source
	 else
		     W25X16_CLK <= 1'b0;
end
//send the command(8bit) and address(24bit) 
always @( posedge div_clk2 or negedge sys_rst_n )  begin 
    if  ( sys_rst_n ==1'b0 )  
           W25X16_DIO <= 1'b0;
	 else			
		  case ( counter  )
				  //the command of read ID(90h)
		        8'd8 :  W25X16_DIO <= 1'b1;
		        8'd9 :  W25X16_DIO <= 1'b0;
		        8'd10:  W25X16_DIO <= 1'b0;
		        8'd11:  W25X16_DIO <= 1'b1;
				  8'd12:  W25X16_DIO <= 1'b0;
				  8'd13:  W25X16_DIO <= 1'b0;
				  8'd14:  W25X16_DIO <= 1'b0;
				  8'd15:  W25X16_DIO <= 1'b0;
				  //the address(000000h)
				  8'd16:  W25X16_DIO <= 1'b0;
				  8'd17:  W25X16_DIO <= 1'b0;
		        8'd18:  W25X16_DIO <= 1'b0;
				  8'd19:  W25X16_DIO <= 1'b0;
				  8'd20:  W25X16_DIO <= 1'b0;
				  8'd21:  W25X16_DIO <= 1'b0;
				  8'd22:  W25X16_DIO <= 1'b0;
				  8'd23:  W25X16_DIO <= 1'b0;
				  8'd24:  W25X16_DIO <= 1'b0;
				  8'd25:  W25X16_DIO <= 1'b0;
              8'd26:  W25X16_DIO <= 1'b0;
				  8'd27:  W25X16_DIO <= 1'b0;
				  8'd28:  W25X16_DIO <= 1'b0;
				  8'd29:  W25X16_DIO <= 1'b0;
				  8'd30:  W25X16_DIO <= 1'b0;
				  8'd31:  W25X16_DIO <= 1'b0;
				  8'd32:  W25X16_DIO <= 1'b0;
				  8'd33:  W25X16_DIO <= 1'b0;
				  8'd34:  W25X16_DIO <= 1'b0;
				  8'd35:  W25X16_DIO <= 1'b0;
				  8'd36:  W25X16_DIO <= 1'b0;
				  8'd37:  W25X16_DIO <= 1'b0;
				  8'd38:  W25X16_DIO <= 1'b0;
				  8'd39:  W25X16_DIO <= 1'b0;
				  default:  W25X16_DIO <= 1'b0;
			endcase
end

// collect the signal from the W25X16_DO 
always @(posedge W25X16_CLK or negedge sys_rst_n )  begin
    if  ( sys_rst_n == 1'b0 )
			  shift_buf <= 16'b0;
    else if  ( counter ==  38 )	//clear the shift_buf
				    shift_buf <= 16'b0;
	 else if  ( counter >= 40 && counter <=  55  ) //the time that collect the ID
				    shift_buf <= { shift_buf[14:0], W25X16_DO};	//save the data from W25X16_DO	
	 else; 		
end

// lock FLASH dev_id when buf is stable
always @(posedge div_clk1 or negedge sys_rst_n )  begin
    if  ( sys_rst_n ==  1'b0 )
			  LED <= 8'b0;
	 else if  ( counter ==  58 )
				    LED[7:0] <= shift_buf[7:0]; 
	 else;
end

endmodule
//end of RTL code                       
