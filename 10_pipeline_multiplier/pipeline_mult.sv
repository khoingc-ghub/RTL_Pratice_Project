`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2026 05:09:52 PM
// Design Name: 
// Module Name: pipeline_mult
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


module pipeline_mult #(
    parameter int DATA_WIDTH = 8
)(
    input  logic                       clk_i,
    input  logic                       rst_ni,

    input  logic [DATA_WIDTH-1:0]      a_i,
    input  logic [DATA_WIDTH-1:0]      b_i,
    input  logic                       valid_i,

    input  logic                       stall_i,
    input  logic                       flush_i,

    output logic [(2*DATA_WIDTH)-1:0]  y_o,
    output logic                       valid_o
);

    logic [DATA_WIDTH-1:0] a_reg;
    logic [DATA_WIDTH-1:0] b_reg;

    logic [(2*DATA_WIDTH)-1:0] y_reg;

    logic valid_1;
    logic valid_2;

    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            a_reg   <= '0;
            b_reg   <= '0;

            y_reg   <= '0;
            y_o     <= '0;

            valid_1 <= 1'b0;
            valid_2 <= 1'b0;
            valid_o <= 1'b0;

        end
        else if (flush_i) begin
            a_reg   <= '0;
            b_reg   <= '0;

            y_reg   <= '0;
            y_o     <= '0;

            valid_1 <= 1'b0;
            valid_2 <= 1'b0;
            valid_o <= 1'b0;

        end
        else if (!stall_i) begin

            // Stage 1
            a_reg   <= a_i;
            b_reg   <= b_i;
            valid_1 <= valid_i;

            // Stage 2
            y_reg   <= a_reg * b_reg;
            valid_2 <= valid_1;

            // Stage 3
            y_o     <= y_reg;
            valid_o <= valid_2;

        end
    end

endmodule
