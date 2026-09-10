`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 06:08:18 PM
// Design Name: 
// Module Name: vending_machine
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


module vending_machine(
    input logic clk_i,
    input logic rst_ni,
    
    input logic coin5_i,
    input logic coin10_i,
    
    output logic change5_o,
    output logic vend_o
    );
    
    typedef enum logic [1:0] {
        ST_IDLE,
        ST_GET5,
        ST_GET10
    } state_e;
    
    state_e state_d, state_q;
    
    always_comb begin
        state_d = state_q;
        vend_o = '0;
        change5_o = '0;
        
        case(state_q)
            ST_IDLE: begin
                if (coin5_i) begin  
                    state_d = ST_GET5;
                end else if (coin10_i) begin  
                    state_d = ST_GET10;
                end
            end
            
            ST_GET5: begin
                if (coin5_i) begin
                    state_d = ST_GET10;
                end else if (coin10_i) begin
                    state_d = ST_IDLE;
                    vend_o = 1'b1;
                end
            end
            
            ST_GET10: begin
                if (coin5_i) begin
                    state_d = ST_IDLE;
                    vend_o = 1'b1;
                end else if (coin10_i) begin
                    state_d = ST_IDLE;
                    vend_o = 1'b1;
                    change5_o = 1'b1;
                end
            end
            
            default: begin
                state_d = ST_IDLE;
            end
        endcase
    end
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            state_q <= ST_IDLE;
        end else begin
            state_q <= state_d;
        end
    end
endmodule
