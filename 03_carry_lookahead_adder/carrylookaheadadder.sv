`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2026 09:46:26 PM
// Design Name: 
// Module Name: carrylookaheadadder
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


module carry_lookahead_adder_4bit (
    input  logic [3:0] a,
    input  logic [3:0] b,
    input  logic       cin,

    output logic [3:0] sum,
    output logic       cout
);

    logic [3:0] p;
    logic [3:0] g;

    logic c1, c2, c3;

    // Propagate and Generate
    assign p = a ^ b;
    assign g = a & b;


    // Carry Lookahead logic
    assign c1 = g[0] | (p[0] & cin);

    assign c2 = g[1] |
                (p[1] & g[0]) |
                (p[1] & p[0] & cin);

    assign c3 = g[2] |
                (p[2] & g[1]) |
                (p[2] & p[1] & g[0]) |
                (p[2] & p[1] & p[0] & cin);

    assign cout = g[3] |
                  (p[3] & g[2]) |
                  (p[3] & p[2] & g[1]) |
                  (p[3] & p[2] & p[1] & g[0]) |
                  (p[3] & p[2] & p[1] & p[0] & cin);


    // Sum
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;


endmodule
