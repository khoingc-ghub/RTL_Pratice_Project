`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 03:08:27 PM
// Design Name: 
// Module Name: tb_round_robin_arbiter
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


module tb_round_robin_arbiter;

    logic       clk_i;
    logic       rst_ni;

    logic [3:0] req_i;
    logic       done_i;

    logic [3:0] gnt_o;
    logic       busy_o;


    round_robin_arbiter dut (
        .clk_i  (clk_i),
        .rst_ni (rst_ni),
        .req_i  (req_i),
        .done_i (done_i),
        .gnt_o  (gnt_o),
        .busy_o (busy_o)
    );


    //==================================================
    // Clock
    //==================================================

    initial begin
        clk_i = 1'b0;
        forever #5 clk_i = ~clk_i;
    end


    //==================================================
    // Reset
    //==================================================

    task automatic reset_dut();
        begin
            rst_ni = 1'b0;
            req_i  = 4'b0000;
            done_i = 1'b0;

            repeat (2) @(posedge clk_i);

            rst_ni = 1'b1;

            @(posedge clk_i);
        end
    endtask


    //==================================================
    // Check grant
    //==================================================

    task automatic check_grant(
        input logic [3:0] expected_gnt,
        input logic       expected_busy
    );
        begin
            #1;

            assert (gnt_o === expected_gnt)
                else $error(
                    "Grant ERROR: expected=%b actual=%b",
                    expected_gnt,
                    gnt_o
                );

            assert (busy_o === expected_busy)
                else $error(
                    "Busy ERROR: expected=%b actual=%b",
                    expected_busy,
                    busy_o
                );
        end
    endtask


    //==================================================
    // Main test
    //==================================================

    initial begin

        rst_ni = 1'b0;
        req_i  = 4'b0000;
        done_i = 1'b0;

        reset_dut();


        //================================================
        // TEST 1
        // All request -> requester 0 should win first
        //================================================

        $display("TEST 1: Initial round-robin priority");

        @(negedge clk_i);
        req_i = 4'b1111;

        @(posedge clk_i);
        check_grant(4'b0001, 1'b1);


        //================================================
        // TEST 2
        // Hold grant while done = 0
        //================================================

        $display("TEST 2: Hold grant until done");

        repeat (3) begin

            @(negedge clk_i);

            // Change requests aggressively
            req_i = $urandom_range(0, 15);

            @(posedge clk_i);

            check_grant(4'b0001, 1'b1);
        end


        //================================================
        // TEST 3
        // Finish requester 0
        //================================================

        $display("TEST 3: Complete requester 0");

        @(negedge clk_i);

        req_i  = 4'b1111;
        done_i = 1'b1;

        @(posedge clk_i);

        check_grant(4'b0000, 1'b0);

        @(negedge clk_i);
        done_i = 1'b0;


        //================================================
        // TEST 4
        // Next priority should be requester 1
        //================================================

        $display("TEST 4: Next requester should be 1");

        @(posedge clk_i);

        check_grant(4'b0010, 1'b1);


        //================================================
        // Complete requester 1
        //================================================

        @(negedge clk_i);
        done_i = 1'b1;

        @(posedge clk_i);
        check_grant(4'b0000, 1'b0);

        @(negedge clk_i);
        done_i = 1'b0;


        //================================================
        // Next should be requester 2
        //================================================

        @(posedge clk_i);
        check_grant(4'b0100, 1'b1);


        //================================================
        // Complete requester 2
        //================================================

        @(negedge clk_i);
        done_i = 1'b1;

        @(posedge clk_i);
        check_grant(4'b0000, 1'b0);

        @(negedge clk_i);
        done_i = 1'b0;


        //================================================
        // Next should be requester 3
        //================================================

        @(posedge clk_i);
        check_grant(4'b1000, 1'b1);


        repeat (2) @(posedge clk_i);

        $display("============================");
        $display("ALL TESTS COMPLETED");
        $display("============================");

        $finish;

    end

endmodule
