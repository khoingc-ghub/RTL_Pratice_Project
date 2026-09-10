`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/16/2026 10:06:38 PM
// Design Name: 
// Module Name: round_robin_arbiter
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


module round_robin_arbiter(
    input  logic clk_i,
    input  logic rst_ni,
    input  logic [3:0] req_i,
    input  logic done_i,
    
    output logic [3:0] gnt_o,
    output logic busy_o
    );
    
    logic [1:0] last_serve_q;
    logic [1:0] last_serve_d;
    logic busy_q, busy_d;
    logic [3:0] gnt_q, gnt_d;
    
    always_comb begin
       gnt_d = gnt_q;
       busy_d = busy_q;
       last_serve_d = last_serve_q;
       
       if (busy_q) begin
           if (done_i) begin
               gnt_d = 4'b0000;
               busy_d = 1'b0;
           end
       end else begin
           gnt_d = 4'b0000;
           
           case(last_serve_q)
                2'b00: begin // request 0 already accept so do 1 first
                    if (req_i[1]) begin
                        gnt_d           = 4'b0010;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b01;
                    end else if (req_i[2]) begin
                        gnt_d           = 4'b0100;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b10;
                    end else if (req_i[3]) begin
                        gnt_d           = 4'b1000;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b11;
                    end else if (req_i[0]) begin
                        gnt_d           = 4'b0001;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b00;
                    end
                end
                
                2'b01: begin // request 1 already accept so do 2 first
                    if (req_i[2]) begin
                        gnt_d           = 4'b0100;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b10;
                    end else if (req_i[3]) begin
                        gnt_d           = 4'b1000;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b11;
                    end else if (req_i[0]) begin
                        gnt_d           = 4'b0001;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b00;
                    end else if (req_i[1]) begin
                        gnt_d           = 4'b0010;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b01;    
                    end
                end
                
                2'b10: begin
                    if (req_i[3]) begin
                        gnt_d           = 4'b1000;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b11;
                    end else if (req_i[0]) begin
                        gnt_d           = 4'b0001;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b00;
                    end else if (req_i[1]) begin
                        gnt_d           = 4'b0010;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b01;
                    end else if (req_i[2]) begin
                        gnt_d           = 4'b0100;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b10;
                    end    
                end
                
                2'b11: begin
                    if (req_i[0]) begin
                        gnt_d           = 4'b0001;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b00;
                    end else if (req_i[1]) begin
                        gnt_d           = 4'b0010;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b01;
                    end else if (req_i[2]) begin
                        gnt_d           = 4'b0100;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b10;
                    end else if (req_i[3]) begin
                        gnt_d           = 4'b1000;
                        busy_d          = 1'b1;
                        last_serve_d    = 2'b11; 
                    end    
                end
                
                default: begin
                    gnt_d = 4'b0000;
                    busy_d = 1'b0;
                    last_serve_d = 2'b11;
                end      
           endcase
       end                             
    end
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if(!rst_ni) begin
            last_serve_q <= 2'b11;
            busy_q <= 1'b0;
            gnt_q <= '0;
        end else begin
            last_serve_q <= last_serve_d;
            busy_q <= busy_d;
            gnt_q <= gnt_d;
        end
    end
    
    assign busy_o = busy_q;
    assign gnt_o = gnt_q;
    
endmodule
