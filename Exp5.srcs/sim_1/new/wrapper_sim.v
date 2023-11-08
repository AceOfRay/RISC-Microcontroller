`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2023 12:11:18 PM
// Design Name: 
// Module Name: wrapper_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module wrapper_sim;
  reg clk;
  reg [4:0] buttons;
  reg [15:0] switches;
  wire [15:0] leds;
  wire [7:0] segs;
  wire [3:0] an;

  // Instantiate the OTTER_Wrapper module
  OTTER_Wrapper uut (
    .clk(clk),
    .buttons(buttons),
    .switches(switches),
    .leds(leds),
    .segs(segs),
    .an(an)
  );

  // Clock generation
  always
    #5 clk = ~clk;

  // Simulation initialization
  initial begin
    clk = 0; // Initialize the clock signal
    switches = 16'h0001; // Initialize switches with 16 bits
    #10 buttons[3] = 1'b1;
    #20 switches = 16'b0010; // Change the switches value after a delay
    #10 buttons[3] = 1'b1;
    // Add any other initializations or tests you need here
  end

  // Your additional test logic can be added here

endmodule
