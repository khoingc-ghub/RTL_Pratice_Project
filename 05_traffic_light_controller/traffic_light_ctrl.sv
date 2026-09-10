`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 05:58:17 PM
// Design Name: 
// Module Name: traffic_light_ctrl
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


module traffic_light_ctrl(
    input logic clk_i,
    input logic rst_ni,
    output logic red,
    output logic green,
    output logic yellow
    );
    
    typedef enum logic [1:0] {
        ST_GREEN,
        ST_YELLOW,
        ST_RED
    } state_e;
    
    state_e state_d,state_q;
    
    logic [2:0] count;
    
    always_comb begin
        state_d = state_q;
        
        case(state_q)
            ST_GREEN:
                if (count == 5) // 6 cycles
                    state_d = ST_YELLOW;
            ST_YELLOW:
                if (count == 3) // 4 cycles
                    state_d = ST_RED;
            ST_RED:
                if (count == 2) // 3 cycles
                    state_d = ST_GREEN;
            default: begin
                state_d = ST_GREEN;
            end                
        endcase        
    end
    
    always_comb begin
        red = '0;
        green = '0;
        yellow = '0;
        
        case(state_q)
            ST_GREEN:
                green = 1;
            ST_YELLOW:
                yellow = 1;
            ST_RED:
                red = 1;
            default:
                red = 1;
        endcase      
    end
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            state_q <= ST_GREEN;
            count <= '0;
        end else begin
            state_q <= state_d;    
            
            if (state_q == state_d) 
                count <= count + 1;
            else
                count <= 0;    
        end    
    end
    
    
    
endmodule
