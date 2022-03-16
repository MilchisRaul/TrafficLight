//--------------------------------------------------------------------------------------------------
// Project     : Button Actioned Pedestrian Traffic Light
// Module Name : ped_traffic_light.v
// Author      : Raul Milchis(RM)
// Created     : Mar 16, 2022
//--------------------------------------------------------------------------------------------------
// Description : This module describes the pedestrian traffic light , a state machine 
//--------------------------------------------------------------------------------------------------
// Modification history :
// 03/16/2022 (RM): Initial version
//--------------------------------------------------------------------------------------------------


`timescale 1ps/1ps

module ped_traffic_light #(
// Parameters IF
  parameter TP = 1 // Time Propagation
)
(
// System IF ---------------------------------------------------------------------------------------
  input  clk         , //clock signal 1 Hz (1 sec)
  input  rst_n       , // Asynchronous reset , active low
  input  btn         , // Button
  
  output ped_green   , // Pedestrian traffic light's Green LED
  output ped_red     , // Pedestrian traffic light's Red LED
  output traff_red   , // Traffic light's Red LED
  output traff_yellow, // Traffic light's Yellow LED
  output traff_green   // Traffic light's Green LED
// output timer         // optional timer output

);
//--------------------------------------------------------------------------------------------------
//                                            LOCAL PARAMETERS
//--------------------------------------------------------------------------------------------------





//--------------------------------------------------------------------------------------------------
//                                            INTERNAL SIGNALS
//-------------------------------------------------------------------------------------------------

wire       ug              ; // unpressed green
wire       pg              ; // pressed green
wire       cg              ; // crossed green
wire       fin_cnt         ; // active when counter finish current state timer
reg  [5:0] counter         ; // Counter for state selection
wire [1:0] state_selection ; // 00 - red , 01 - yellow , 10 - ug , 11 - pg
wire       state_to_compare; // state to compare with counter

//--------------------------------------------------------------------------------------------------
//                                                  CODE
//--------------------------------------------------------------------------------------------------

assign traff_green = ug | pg | cg;
assign ped_green = traff_red;
assign ped_red = traff_green | traff_yellow;



//COUNTER DESIGN 
always @(posedge clk or negedge rst_n)
if(rst_n  ) counter <= 6'd0          ;else
if(~cg    ) counter <= counter + 6'd1;else 
if(fin_cnt) counter <= 6'd0          ;

// ENCODER 2^2 : 2 
always @(*)
if(traff_red)    state_selection <= 2'b00;else 
if(traff_yellow) state_selection <= 2'b01;else
if(ug)           state_selection <= 2'b10;else
if(pg)           state_selection <= 2'b11;else
                 state_selection <= 2'b10;

// MUX 4:1 
always @(*)
case(state_selection) 
  2'b00: state_to_compare = 6'b01_1101; // 29s                                      RED
  2'b01: state_to_compare = 6'b00_0100; // 4s                                       YELLOW 
  2'b10: state_to_compare = 6'b11_1011; // 59s                                      UG
default: state_to_compare = 6'b11_1011; // 59s, default (case 2'b11, 'dx or others) PG


assign fin_cnt = (counter == state_to_compare);



endmodule    