`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/14/2026 05:58:12 PM
// Design Name: 
// Module Name: tb_pipeline_multiplier
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



module tb_pipeline_multiplier;

    parameter int DATA_WIDTH = 8;

    logic clk_i;
    logic rst_ni;

    logic [DATA_WIDTH-1:0] a_i;
    logic [DATA_WIDTH-1:0] b_i;

    logic valid_i;
    logic stall_i;
    logic flush_i;

    logic [(2*DATA_WIDTH)-1:0] y_o;
    logic valid_o;

    // =========================================================
    // DUT
    // =========================================================
    pipeline_mult #(
        .DATA_WIDTH(DATA_WIDTH)
    ) DUT (
        .clk_i   (clk_i),
        .rst_ni  (rst_ni),

        .a_i     (a_i),
        .b_i     (b_i),
        .valid_i (valid_i),

        .stall_i (stall_i),
        .flush_i (flush_i),

        .y_o     (y_o),
        .valid_o (valid_o)
    );

    // =========================================================
    // Clock
    // =========================================================
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

    // =========================================================
    // Send one input
    // =========================================================
    task send_data(
        input logic [DATA_WIDTH-1:0] a,
        input logic [DATA_WIDTH-1:0] b,
        input logic                  valid
    );

        begin
            @(negedge clk_i);

            a_i     = a;
            b_i     = b;
            valid_i = valid;
        end

    endtask

    // =========================================================
    // Monitor
    // =========================================================
    always @(posedge clk_i) begin
        #1;

        $display(
            "valid_i=%b a=%0d b=%0d | stall=%b flush=%b | valid_o=%b y=%0d",
            valid_i,
            a_i,
            b_i,
            stall_i,
            flush_i,
            valid_o,
            y_o
        );
    end

    // =========================================================
    // Test
    // =========================================================
    initial begin
        rst_ni  = 0;

        a_i     = 0;
        b_i     = 0;
        valid_i = 0;

        stall_i = 0;
        flush_i = 0;

        // -----------------------------------------------------
        // RESET
        // -----------------------------------------------------
        repeat (2)
            @(negedge clk_i);

        rst_ni = 1;

        // =====================================================
        // TEST 1 - Normal operation
        // =====================================================
        $display("===== TEST 1: NORMAL PIPELINE =====");

        send_data(8'd3, 8'd4, 1'b1);   // 12
        send_data(8'd5, 8'd6, 1'b1);   // 30
        send_data(8'd7, 8'd8, 1'b1);   // 56

        send_data(0, 0, 1'b0);

        repeat(4)
            @(posedge clk_i);

        // =====================================================
        // TEST 2 - Stall
        // =====================================================
        $display("===== TEST 2: STALL =====");

        // transaction A
        send_data(8'd2, 8'd5, 1'b1);   // 10

        // transaction B
        send_data(8'd4, 8'd6, 1'b1);   // 24

        // Stall pipeline for 2 cycles
        @(negedge clk_i);

        stall_i = 1'b1;
        valid_i = 1'b0;

        repeat (2)
            @(negedge clk_i);

        // Release stall
        stall_i = 1'b0;

        // transaction C
        a_i     = 8'd3;
        b_i     = 8'd9;
        valid_i = 1'b1;

        @(negedge clk_i);

        valid_i = 1'b0;

        repeat(5)
            @(posedge clk_i);

        // =====================================================
        // TEST 3 - FLUSH
        // =====================================================
        $display("===== TEST 3: FLUSH =====");

        // Put some valid transactions in pipeline
        send_data(8'd10, 8'd10, 1'b1); // 100
        send_data(8'd11, 8'd11, 1'b1); // 121

        // Flush before they finish
        @(negedge clk_i);

        flush_i = 1'b1;
        valid_i = 1'b0;

        @(negedge clk_i);

        flush_i = 1'b0;

        // After flush, these old transactions
        // must NOT appear with valid_o = 1
        repeat(4)
            @(posedge clk_i);

        // =====================================================
        // TEST 4 - Pipeline works again after flush
        // =====================================================
        $display("===== TEST 4: AFTER FLUSH =====");

        send_data(8'd8, 8'd8, 1'b1);   // 64

        send_data(0, 0, 1'b0);

        repeat(5)
            @(posedge clk_i);

        $display("");
        $display("===========================");
        $display("       TEST COMPLETE");
        $display("===========================");

        $finish;

    end

endmodule
