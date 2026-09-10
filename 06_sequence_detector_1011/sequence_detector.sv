`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/11/2026 07:56:45 PM
// Design Name: 
// Module Name: sequence_detector
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


module sequence_detector(
    input logic clk_i,
    input logic rst_ni,
    input logic bit_i,
    output logic y_o
    );
    
    typedef enum logic [2:0] {
        ST_IDLE,
        ST_1,
        ST_10,
        ST_101,
        ST_1011   
    } state_e;
    
    state_e state_d, state_q;
    
    always_comb begin
        state_d = state_q;
        
        case(state_q)
            ST_IDLE:
                if (bit_i == 1'b1) 
                    state_d = ST_1;
            ST_1:
                if (bit_i == 1'b0)
                    state_d = ST_10;
                else
                    state_d = ST_1;
            ST_10:
                if (bit_i == 1'b1)
                    state_d = ST_101;
                else
                    state_d = ST_IDLE;
            ST_101:
                if (bit_i == 1'b1)
                    state_d = ST_1011;
                else
                    state_d = ST_10;
            ST_1011:
                if (bit_i == 1'b1)
                    state_d = ST_1;
                else
                    state_d = ST_10;  
            default:
                state_d = ST_IDLE;                                          
        endcase            
    end
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            state_q <= ST_IDLE;
        end else
            state_q <= state_d;
    end
    
    always_comb begin
        y_o = '0;
        
        if (state_q == ST_1011)
            y_o = 1'b1;
    end
    
endmodule
