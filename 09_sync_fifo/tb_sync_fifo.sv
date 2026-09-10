`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/13/2026 05:50:57 PM
// Design Name: 
// Module Name: tb_sync_fifo
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


`timescale 1ns / 1ps

module tb_sync_fifo #(
    parameter int DATA_WIDTH = 8,
    parameter int DEPTH      = 4
);

    logic clk_i;
    logic rst_ni;

    logic rd_en_i;
    logic wr_en_i;

    logic [DATA_WIDTH-1:0] wr_data_i;
    logic [DATA_WIDTH-1:0] rd_data_o;

    logic full_o;
    logic empty_o;


    // DUT

    sync_fifo #(
        .DATA_WIDTH (DATA_WIDTH),
        .DEPTH      (DEPTH)
    ) DUT (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .wr_en_i    (wr_en_i),
        .wr_data_i  (wr_data_i),

        .rd_en_i    (rd_en_i),
        .rd_data_o  (rd_data_o),

        .fully_o    (full_o),
        .empty_o    (empty_o)
    );

    // Clock

    initial begin
        clk_i = 1'b0;

        forever #5 clk_i = ~clk_i;
    end


    // WRITE TASK

    task write_data(
        input logic [DATA_WIDTH-1:0] data
    );

        logic accepted;

        begin

            @(negedge clk_i);

            // FIFO accepct write ?
            accepted = !full_o;

            wr_en_i   = 1'b1;
            wr_data_i = data;

            // write 
            @(posedge clk_i);

            #1;

            @(negedge clk_i);

            wr_en_i = 1'b0;

            if (accepted) begin
                $display(
                    "[PASS] WRITE %h | full=%b empty=%b",
                    data,
                    full_o,
                    empty_o
                );
            end
            else begin
                $display(
                    "[PASS] WRITE %h REJECTED - FIFO FULL",
                    data
                );
            end

        end

    endtask


    // READ TASK

    task read_data(
        input logic [DATA_WIDTH-1:0] expected
    );

        logic accepted;

        begin

            @(negedge clk_i);

            accepted = !empty_o;

            rd_en_i = 1'b1;

            // read 
            @(posedge clk_i);

            #1;

            if (accepted) begin

                if (rd_data_o === expected) begin

                    $display(
                        "[PASS] READ %h | expected=%h | full=%b empty=%b",
                        rd_data_o,
                        expected,
                        full_o,
                        empty_o
                    );

                end
                else begin

                    $display(
                        "[FAIL] READ %h | expected=%h",
                        rd_data_o,
                        expected
                    );

                end

            end
            else begin

                $display(
                    "[PASS] READ REJECTED - FIFO EMPTY"
                );

            end

            @(negedge clk_i);

            rd_en_i = 1'b0;

        end

    endtask


    // Simultaneous READ + WRITE in same clk

    task read_write_same_cycle(
        input logic [DATA_WIDTH-1:0] write_data,
        input logic [DATA_WIDTH-1:0] expected_read
    );

        begin

            @(negedge clk_i);

            wr_en_i   = 1'b1;
            rd_en_i   = 1'b1;
            wr_data_i = write_data;

            @(posedge clk_i);

            #1;

            if (rd_data_o === expected_read) begin

                $display(
                    "[PASS] SIM READ=%h WRITE=%h",
                    rd_data_o,
                    write_data
                );

            end
            else begin

                $display(
                    "[FAIL] SIM READ=%h expected=%h",
                    rd_data_o,
                    expected_read
                );

            end

            @(negedge clk_i);

            wr_en_i = 1'b0;
            rd_en_i = 1'b0;

        end

    endtask


    // TEST

    initial begin

        rst_ni    = 1'b0;
        wr_en_i   = 1'b0;
        rd_en_i   = 1'b0;
        wr_data_i = '0;


        // RESET

        repeat (2)
            @(negedge clk_i);

        rst_ni = 1'b1;

        #1;

        if (empty_o && !full_o)
            $display("[PASS] RESET: FIFO EMPTY");
        else
            $display("[FAIL] RESET");

        // WRITE 4 ELEMENTS
        write_data(8'hFF);
        write_data(8'h12);
        write_data(8'h67);
        write_data(8'h36);

        // CHECK FULL
        if (full_o)
            $display("[PASS] FIFO FULL");
        else
            $display("[FAIL] FIFO SHOULD BE FULL");

        // WRITE WHEN FULL
        // Should be rejected
        write_data(8'h33);
        
        // READ FIRST TWO
        read_data(8'hFF);
        read_data(8'h12);


        // FIFO 
        //
        // 67
        // 36

        // SIMULTANEOUS READ + WRITE
        // read  = 67
        // write = E5

        // FIFO after:
        // 36
        // E5

        read_write_same_cycle(
            8'hE5,
            8'h67
        );

        // READ REMAINING
        read_data(8'h36);
        read_data(8'hE5);


        // FIFO SHOULD NOW BE EMPTY
        if (empty_o)
            $display("[PASS] FIFO EMPTY");
        else
            $display("[FAIL] FIFO SHOULD BE EMPTY");

        // READ WHILE EMPTY
        read_data('0);

        // POINTER WRAP-AROUND TEST
        //
        // FIFO vừa được dùng hết một vòng pointer. 

        write_data(8'hA1);
        write_data(8'hB2);
        write_data(8'hC3);
        write_data(8'hD4);

        read_data(8'hA1);
        read_data(8'hB2);
        read_data(8'hC3);
        read_data(8'hD4);


        if (empty_o)
            $display("[PASS] WRAP-AROUND TEST DONE");
        else
            $display("[FAIL] WRAP-AROUND TEST");


        $display("");
        $display("==========================");
        $display("      TEST COMPLETE");
        $display("==========================");

        #20;

        $finish;

    end

endmodule