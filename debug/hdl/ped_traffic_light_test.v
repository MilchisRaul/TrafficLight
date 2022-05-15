//--------------------------------------------------------------------------------------------------
//University Transilvania of Brasov
// Project     : Button actioned pedestrian traffic light
// Module Name : ped_traffic_light_test.v
// Author      : Raul Milchis(RM)
// Created     : Apr 27, 2022
//--------------------------------------------------------------------------------------------------
// Description : Button actioned pedestrian traffic light Test Envoirement (Test)
//--------------------------------------------------------------------------------------------------
// Modification history :
// 04/27/2022 (RM): Initial version
//--------------------------------------------------------------------------------------------------

module ped_traffic_light_test;


localparam TP = 1;

wire clk         ;
wire rst_n       ;
wire btn         ;

wire ped_green   ;
wire ped_red     ;
wire traff_red   ;
wire traff_yellow;
wire traff_green ;




ped_traffic_light_tb i_ped_traffic_light_tb(
  .clk  (clk  ), //clock signal 1 Hz (1 sec)
  .rst_n(rst_n), // Asynchronous reset , active low
  .btn  (btn  )  // Button
);

ck_rst_tb #(
  .CK_SEMIPERIOD('d10 )  // CK semi-period 
)i_ck_rst_tb(
  .clk          (clk  ), // ck signal
  .rst_n        (rst_n)  // asynchrnous reset , active low
);  

ped_traffic_light #(
// Parameters IF
  .TP          (TP)// Time Propagation
)i_ped_traffic_light(
// System IF ---------------------------------------------------------------------------------------
  .clk         (clk         ), //clock signal 1 Hz (1 sec)
  .rst_n       (rst_n       ), // Asynchronous reset , active low
  .btn         (btn         ), // Button
  
  .ped_green   (ped_green   ), // Pedestrian traffic light's Green LED
  .ped_red     (ped_red     ), // Pedestrian traffic light's Red LED
  .traff_red   (traff_red   ), // Traffic light's Red LED
  .traff_yellow(traff_yellow), // Traffic light's Yellow LED
  .traff_green (traff_green )  // Traffic light's Green LED
// output timer         // optional timer output

);

endmodule    