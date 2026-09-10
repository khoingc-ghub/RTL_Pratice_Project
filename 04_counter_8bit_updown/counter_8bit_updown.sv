`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 08:39:35 AM
// Design Name: 
// Module Name: counter_8bit_updown
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


module counter_8bit_updown(
    input logic clk_i,
    input logic rst_ni,
    input logic up_down_i,
    output logic [7:0] count_o
    );
    
    logic [7:0] cnt;
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni)
            count_o <= '0;
        else if (up_down_i) begin
            count_o <= count_o - 1;
        end else
            count_o <= count_o + 1;   
    end
    
endmodule
