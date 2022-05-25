module traffic_light_top(
  input clk          ,
  input rst_n        ,
  input btn          ,

  output ped_green   ,
  output ped_red     ,
  output traff_red   ,
  output traff_yellow,
  output traff_green 
);

ped_traffic_light #(
// Parameters IF
  .TP          (1           ) // Time Propagation
)i_ped_traffic_light
(
// System IF ---------------------------------------------------------------------------------------
  .clk         (sec         ), // clock signal needs to be 1 Hz (1 sec)
  .rst_n       (rst_n       ), // Asynchronous reset , active low
  .btn         (btn         ), // Button
  
  .ped_green   (ped_green   ), // Pedestrian traffic light's Green LED
  .ped_red     (ped_red     ), // Pedestrian traffic light's Red LED
  .traff_red   (traff_red   ), // Traffic light's Red LED
  .traff_yellow(traff_yellow), // Traffic light's Yellow LED
  .traff_green (traff_green )  // Traffic light's Green LED
// output timer         // optional timer output
);

localparam CNT_TO_FLAG = 'd12000000; // 1 sec


wire         sec;
reg [32-1:0] cnt;

always @(posedge clk or negedge rst_n) 
  if(~rst_n) cnt <= 'd0      ;else
  if(sec)    cnt <= 'd0      ;else
             cnt <= cnt + 'd1;    

assign sec = (cnt == CNT_TO_FLAG);


endmodule