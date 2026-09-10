`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/07/2026 08:58:49 PM
// Design Name: 
// Module Name: tb_4bit_ripplecarryadder
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


module tb_4bit_ripplecarryadder;
    logic [3:0] a;
    logic [3:0] b;
    logic       cin;
    logic [3:0] sout;
    logic       cout;
    logic [4:0] expected;
    
    ripplecarryadder DUT (
        .a(a),
        .b(b),
        .cin(cin),
        .sout(sout),
        .cout(cout)
    );    
    
    task test(
        input logic [3:0] test_a,
        input logic [3:0] test_b,
        input logic       test_cin
    );
        begin
            a = test_a;
            b = test_b;
            cin = test_cin;
            
            #1
            
            expected = test_a + test_b + test_cin;
            
            if ({cout,sout} == expected)
                $display("PASS: a=%b, b=%b, cin=%b -> result=%b" , a, b, cin, {cout,sout});
            else
                $display("FAIL: a=%b, b=%b, cin=%b, got=%b but expectd=%b", a, b, cin, {cout,sout}, expected);
        end
    endtask
   
    initial begin
        test(4'b0000, 4'b0000, 1'b0); test(4'b0101, 4'b0011, 1'b0); // 5 + 3 
        test(4'b1111, 4'b0001, 1'b0); // 15 + 1 
        test(4'b0111, 4'b1000, 1'b0); // 7 + 8 
        test(4'b1010, 4'b0101, 1'b1); // 10 + 5 + 1
        repeat (10) begin
            test($urandom_range(15, 0), $urandom_range(15, 0), $urandom_range(1, 0));
        end
        $finish;
    end                  
endmodule
