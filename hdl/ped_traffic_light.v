//--------------------------------------------------------------------------------------------------
// University Transilvania of Brasov
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
  input  clk         , // clock signal needs to be 1 Hz (1 sec)
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

localparam UNPRESSED_GREEN = 4'b000;
localparam PRESSED_GREEN   = 4'b001;
localparam CROSSED_GREEN   = 4'b010;
localparam YELLOW          = 4'b011;
localparam RED             = 4'b100;



//--------------------------------------------------------------------------------------------------
//                                            INTERNAL SIGNALS
//-------------------------------------------------------------------------------------------------
//Frequency divider
wire        sample_en ;
reg  [26:0] count     ;
wire [31:0] div_factor;

//Ped traffic light
wire          ug              ; // unpressed green
wire          pg              ; // pressed green
wire          cg              ; // crossed green
wire          fin_cnt         ; // active when counter finish current state timer
reg [6 - 1:0] counter         ; // Counter for state selection
// reg [2 - 1:0] current_state   ;
reg [6 - 1:0] state_to_compare; // state to compare with counter
reg [6 - 1:0] state_to_compare_d; // state to compare with counter delayed 1 TCK
//FSM Logic

reg [2:0] state     ; // 000 - UG , 001 - PG , 010 - CG , 011 - YELLOW , 100 - RED
reg [2:0] next_state;

//--------------------------------------------------------------------------------------------------
//                                                  CODE
//--------------------------------------------------------------------------------------------------

//Pedestrian traffic light              

assign traff_green = ug | pg | cg;
assign ped_green = traff_red;
assign ped_red = traff_green | traff_yellow;

//COUNTER DESIGN 
//--------------------------------------------------------------------------------------------------
always @(posedge clk or negedge rst_n)
if(~rst_n ) counter <= 6'd0          ;else
if(fin_cnt) counter <= 6'd0          ;else
if(~cg    ) counter <= counter + 6'd1;    // enabled if not crossed green(noone pushed the button after 60s)

// MUX 4:1 
always @(*)
case({traff_red,traff_yellow,ug,pg}) 
  4'b1000:    state_to_compare = 6'b01_1101; // 29s                                      RED
  4'b0100:    state_to_compare = 6'b00_0100; // 4s                                       YELLOW 
  4'b0010:    state_to_compare = 6'b11_1011; // 59s                                      UG
  default:    state_to_compare = 6'b11_1011; // 59s, default (case 2'b11, 'dx or others) PG
endcase

  assign fin_cnt = (counter == state_to_compare_d);
//--------------------------------------------------------------------------------------------------

//state to compare delayed
always @(posedge clk or negedge rst_n)
  if(~rst_n) state_to_compare_d <= 'd0;else
             state_to_compare_d <= state_to_compare;


//FSM Code

//STATE REGISTER
always @(posedge clk or negedge rst_n)
begin
  if(~rst_n) state <= 'b000     ;else       
             state <= next_state;
end
//STATE SWITCH LOGIC
always @(*) 
case (state)
  UNPRESSED_GREEN: if(btn & ~fin_cnt) next_state = PRESSED_GREEN  ;else
                   if(~btn & fin_cnt) next_state = CROSSED_GREEN  ;else
                                      next_state = UNPRESSED_GREEN; 
  PRESSED_GREEN  : if(fin_cnt)        next_state = YELLOW       ;
       
  CROSSED_GREEN  : if(btn)     next_state = YELLOW       ;else
                               next_state = CROSSED_GREEN;
  YELLOW         : if(fin_cnt) next_state = RED   ;else
                               next_state = YELLOW;
  default        : if(fin_cnt) next_state = UNPRESSED_GREEN;else
                               next_state = RED            ;                                                                                              
endcase  
 
// DECODER for states (only 1 state at one moment) ONE HOT

 assign {traff_red,traff_yellow,cg,pg,ug} = 5'b00001 << next_state; // shifts with next_state value



endmodule        