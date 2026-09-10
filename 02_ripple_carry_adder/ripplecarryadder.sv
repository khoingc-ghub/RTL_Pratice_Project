`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2026 08:58:12 PM
// Design Name: 
// Module Name: ripplecarryadder
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


module ripplecarryadder(
    input   logic [3:0] a,
    input   logic [3:0] b,
    input   logic       cin,
    output  logic [3:0] sout,
    output  logic       cout    
    );
    
    logic [3:0] temp_cout;
    
    genvar i;
    generate
        for (i = 0; i < 4; i++) begin : genFA
            full_adder FA ( 
                .a(a[i]), 
                .b(b[i]), 
                .cin( i == 0 ? cin : temp_cout[i-1]), 
                .sout(sout[i]), 
                .cout(temp_cout[i]) 
            );
        end
    endgenerate
    
    assign cout = temp_cout[3];
endmodule
