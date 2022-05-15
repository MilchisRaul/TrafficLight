//--------------------------------------------------------------------------------------------------
//University Transilvania of Brasov
// Project     : Button actioned pedestrian traffic light
// Module Name : ped_traffic_light_tb.v
// Author      : Raul Milchis(RM)
// Created     : Apr 27, 2022
//--------------------------------------------------------------------------------------------------
// Description : Button actioned pedestrian traffic light Test Bench (TB)
//--------------------------------------------------------------------------------------------------
// Modification history :
// 04/27/2022 (RM): Initial version
//--------------------------------------------------------------------------------------------------


module ped_traffic_light_tb(
  input      clk         , //clock signal 1 Hz (1 sec)
  input      rst_n       , // Asynchronous reset , active low
  output reg btn           // Button
);


initial begin
    btn <= 'bx;
@(posedge rst_n);
    btn <= 'b0;
@(posedge rst_n);
repeat(10) @(posedge clk);
    btn <= 'b1;
@(posedge clk);
    btn <= 'b0;
repeat(5) @(posedge clk);
    btn <= 'b1;
@(posedge clk);
    btn <= 'b0;
@(posedge clk);
    btn <= 'b1;
@(posedge clk);
    btn <= 'b0;
repeat(60) @(posedge clk);
    btn <= 'b1;
@(posedge clk);
    btn <= 'b0;
repeat(100) @(posedge clk);
$stop;
end
endmodule