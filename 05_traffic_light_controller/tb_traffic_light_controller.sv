`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 06:28:45 PM
// Design Name: 
// Module Name: tb_traffic_light_controller
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


module tb_traffic_light_controller;

    logic clk;
    logic rst_n;

    logic red;
    logic yellow;
    logic green;

    traffic_light_ctrl dut (
        .clk_i    (clk),
        .rst_ni  (rst_n),
        .red    (red),
        .yellow (yellow),
        .green  (green)
    );

    // Clock 10ns
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        rst_n = 0;

        #12;
        rst_n = 1;

        // chạy đủ lâu để quan sát vài vòng FSM
        repeat (30)
            @(posedge clk);

        $finish;
    end

    initial begin
        $monitor(
            "time=%0t | R=%b Y=%b G=%b",
            $time,
            red,
            yellow,
            green
        );
    end

endmodule
