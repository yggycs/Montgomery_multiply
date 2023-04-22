`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/22 20:38:56
// Design Name: 
// Module Name: test_montgomery_sim
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


module test_montgomery_sim();

    reg clock;
    reg reset;
    wire[127:0] io_A, io_B;
    wire io_valid, flag;
    
    initial clock = 0;
    always #50 clock = ~clock;
    
    initial begin
        reset = 1;
        #100 reset = 0;
    end
    
    test_multiply u_t(
        .clock(clock),
        .reset(reset),
        .io_A(io_A),
        .io_B(io_B),
        .io_valid(io_valid),
        .flag(flag)
    ); 
endmodule
