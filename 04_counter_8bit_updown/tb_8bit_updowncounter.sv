`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 08:40:05 AM
// Design Name: 
// Module Name: tb_8bit_updowncounter
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


module tb_8bit_updowncounter;
    logic clk;
    logic rst_n;
    logic updown;
    logic [7:0] count;
    
    counter_8bit_updown DUT (
        .clk_i(clk),
        .rst_ni(rst_n),
        .up_down_i(updown),
        .count_o(count)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst_n = 0;
        updown = 0;
        
        #10;
        rst_n = 1;
        
        repeat (18)
            @(posedge clk);
            
        updown = 1;
        
        repeat (18)
            @(posedge clk);
        $finish;    
        
    end
endmodule
