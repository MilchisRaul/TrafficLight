//--------------------------------------------------------------------------------------------------
//University Transilvania of Brasov
// Project     : Clock and reset tb
// Module Name : ck_rst_tb.v
// Author      : Raul Milchis(RM)
// Created     : Mar 14, 2022
//--------------------------------------------------------------------------------------------------
// Description : Clock and reset signals generator (TB)
//--------------------------------------------------------------------------------------------------
// Modification history :
// 03/14/2022 (RM): Initial version
//--------------------------------------------------------------------------------------------------

`timescale 1ps/1ps

module ck_rst_tb #(
parameter CK_SEMIPERIOD = 'd10        // CK semi-period
)(
output reg              clk         , // ck signal
output reg              rst_n         // asynchrnous reset , active low
);  
initial 
begin
  clk = 1'b0;             // initial value 0
  forever #CK_SEMIPERIOD  // complemented value at each ck semi-period
    clk = ~clk;
end

initial begin
  rst_n <= 1'b1;    
  @(posedge clk);
  rst_n <= 1'b0;    
  @(posedge clk);
  @(posedge clk);
  rst_n <= 1'b1;    
  @(posedge clk);   
end

endmodule // ck_rst_tb
