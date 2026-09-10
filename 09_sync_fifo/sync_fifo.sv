`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2026 03:34:44 PM
// Design Name: 
// Module Name: sync_fifo
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


module sync_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH = 4
)(
    input   logic                   clk_i,
    input   logic                   rst_ni,
    input   logic                   wr_en_i,
    input   logic [DATA_WIDTH-1:0]  wr_data_i,
    input   logic                   rd_en_i,
    output  logic [DATA_WIDTH-1:0]  rd_data_o,
    output  logic                   fully_o,
    output  logic                   empty_o
    );
    
    localparam int PTR_WIDTH = $clog2(DEPTH);
    
    logic [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    
    logic [PTR_WIDTH:0] cnt;
    logic [PTR_WIDTH-1:0] wr_ptr;
    logic [PTR_WIDTH-1:0] rd_ptr;
    
    logic do_read,do_write;
    
    assign fully_o = (cnt == 4);
    assign empty_o = (cnt == 0);
    assign do_read = rd_en_i && !empty_o;
    assign do_write = wr_en_i && !fully_o;
    
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            rd_data_o <= '0;
            cnt <= '0;
            wr_ptr <= '0;
            rd_ptr <= '0;
        end else begin
            
            // WRITE
            if (do_write) begin
                mem[wr_ptr] <= wr_data_i;
                wr_ptr <= wr_ptr + 1'b1;
            end
            
            // READ
            if (do_read) begin
                rd_data_o <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1'b1;
            end
            
            case({do_write, do_read})
                2'b01:
                    cnt <= cnt - 1'b1;
                2'b10:
                    cnt <= cnt + 1'b1;
                default:
                    cnt <= cnt;        
            endcase
        end
    end
    
    
    
endmodule
