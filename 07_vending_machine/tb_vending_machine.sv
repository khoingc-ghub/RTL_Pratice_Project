`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 06:43:34 PM
// Design Name: 
// Module Name: tb_vending_machine
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



module tb_vending_machine;

    logic clk_i;
    logic rst_ni;

    logic coin5_i;
    logic coin10_i;

    logic change5_o;
    logic vend_o;


    //==================================================
    // DUT
    //==================================================

    vending_machine dut (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),
        .coin5_i    (coin5_i),
        .coin10_i   (coin10_i),
        .change5_o  (change5_o),
        .vend_o     (vend_o)
    );


    //==================================================
    // Clock
    //==================================================

    initial begin
        clk_i = 1'b0;

        forever #5 clk_i = ~clk_i;
    end


    //==================================================
    // Reset task
    //==================================================

    task automatic reset_dut();
        begin
            rst_ni   = 1'b0;
            coin5_i  = 1'b0;
            coin10_i = 1'b0;

            repeat (2) @(posedge clk_i);

            rst_ni = 1'b1;

            @(posedge clk_i);
        end
    endtask


    //==================================================
    // Insert coin 5
    //==================================================

    task automatic insert_coin5();
        begin
            @(negedge clk_i);

            coin5_i  = 1'b1;
            coin10_i = 1'b0;

            @(negedge clk_i);

            coin5_i = 1'b0;
        end
    endtask


    //==================================================
    // Insert coin 10
    //==================================================

    task automatic insert_coin10();
        begin
            @(negedge clk_i);

            coin5_i  = 1'b0;
            coin10_i = 1'b1;

            @(negedge clk_i);

            coin10_i = 1'b0;
        end
    endtask


    //==================================================
    // Main test
    //==================================================

    initial begin

        // Initial value
        clk_i    = 1'b0;
        rst_ni   = 1'b0;
        coin5_i  = 1'b0;
        coin10_i = 1'b0;


        //================================================
        // Reset
        //================================================

        reset_dut();


        //================================================
        // TEST 1
        // 5 + 10 = 15
        //================================================

        $display("TEST 1: 5 + 10");

        insert_coin5();

        @(negedge clk_i);
        coin10_i = 1'b1;

        #1;

        if (vend_o !== 1'b1)
            $error("TEST 1 FAILED: vend_o should be 1");

        if (change5_o !== 1'b0)
            $error("TEST 1 FAILED: change5_o should be 0");

        @(negedge clk_i);
        coin10_i = 1'b0;

        #1;

        if (vend_o !== 1'b0)
            $error("TEST 1 FAILED: vend_o should return to 0");


        //================================================
        // TEST 2
        // 10 + 5 = 15
        //================================================

        $display("TEST 2: 10 + 5");

        insert_coin10();

        @(negedge clk_i);
        coin5_i = 1'b1;

        #1;

        if (vend_o !== 1'b1)
            $error("TEST 2 FAILED: vend_o should be 1");

        if (change5_o !== 1'b0)
            $error("TEST 2 FAILED: change5_o should be 0");

        @(negedge clk_i);
        coin5_i = 1'b0;


        //================================================
        // TEST 3
        // 5 + 5 + 5 = 15
        //================================================

        $display("TEST 3: 5 + 5 + 5");

        insert_coin5();
        insert_coin5();

        @(negedge clk_i);
        coin5_i = 1'b1;

        #1;

        if (vend_o !== 1'b1)
            $error("TEST 3 FAILED: vend_o should be 1");

        if (change5_o !== 1'b0)
            $error("TEST 3 FAILED: change5_o should be 0");

        @(negedge clk_i);
        coin5_i = 1'b0;


        //================================================
        // TEST 4
        // 10 + 10 = 20
        // vend = 1
        // change = 5
        //================================================

        $display("TEST 4: 10 + 10");

        insert_coin10();

        @(negedge clk_i);
        coin10_i = 1'b1;

        #1;

        if (vend_o !== 1'b1)
            $error("TEST 4 FAILED: vend_o should be 1");

        if (change5_o !== 1'b1)
            $error("TEST 4 FAILED: change5_o should be 1");

        @(negedge clk_i);
        coin10_i = 1'b0;


        //================================================
        // Finish
        //================================================

        repeat (2) @(posedge clk_i);

        $display("=============================");
        $display("ALL TESTS COMPLETED");
        $display("=============================");

        $finish;

    end

endmodule
