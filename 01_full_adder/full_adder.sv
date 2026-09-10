`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2026 09:02:15 PM
// Design Name: 
// Module Name: full_adder
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


module full_adder(
    input   logic a,
    input   logic b,
    input   logic cin,
    output  logic sout,
    output  logic cout   
    );
    
    assign sout = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule
