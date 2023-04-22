`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/20 14:35:53
// Design Name: 
// Module Name: montgomery_multiply
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


module montgomery_multiply(
    input                   clock,
    input                   reset,
    input                   io_in_valid,
    input   [127:0]         io_A,
    input   [127:0]         io_B,
    output                  io_out_valid,
    output  [127:0]         io_C
    );
    
    reg[255:0] res;
    reg out_valid;
    
    assign io_C = res[127:0];
    assign io_out_valid = out_valid;
    
    // 此处假设一个周期内就完成结果
    always@(posedge clock or posedge reset) begin
        // 复位
        if(reset) begin
            res <= 0;
            out_valid <= 0;
        end
        // 写入无效
        else if(~io_in_valid) begin
            res <= 0;
            out_valid <= 0;
        end
        // 正常运算
        else begin
            res <= (io_A * io_B) % 128'd170141183460469231731687303715885907969;
            out_valid <= 1'b1;
        end
    end
    
endmodule
