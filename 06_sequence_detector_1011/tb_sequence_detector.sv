`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2026 12:08:54 PM
// Design Name: 
// Module Name: tb_sequence_detector
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


module tb_sequence_detector;

    logic clk_i;
    logic rst_ni;
    logic bit_i;
    logic y_o;
    
    sequence_detector DUT (
        .clk_i(clk_i),
        .rst_ni(rst_ni),
        .bit_i(bit_i),
        .y_o(y_o)
    );
    
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    task send_bit(
        input logic bit_in
    );
        begin
            @(negedge clk_i);
            bit_i = bit_in;
        end
    endtask
        
    initial begin
        rst_ni = 0;
        bit_i = 0;
        
        repeat(2)
            @(negedge clk_i);
        
        rst_ni = 1;    
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        send_bit(0);
        send_bit(1);
        send_bit(1);
        $finish;
    end
    
endmodule
