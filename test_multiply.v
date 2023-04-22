`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/22 18:29:59
// Design Name: 
// Module Name: test_multiply
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


module test_multiply(
    input                   clock,          // 时钟信号
    input                   reset,          // 复位信号，高电平有效
    output [127:0]          io_A,           // 操作数A
    output [127:0]          io_B,           // 操作数B
    output reg              io_valid,       // 指示该次数据是否有效
    output                  flag            // 判断结果是否正确，若正确则输出高电平
    );
    
    reg[1:0] counter;           // 指示该次访存拿回来的数是A，B，C还是当前处于比较状态（相当于一个逻辑很简单的状态机）    
    reg invalid;                // 传到模乘模块的输入数据有效位
    wire outvalid;              // 模乘模块传来的输出数据有效位
    wire[127:0] rdata;          // 从内存取回的数    
    reg[127:0] A, B, C;         // 存储来自ROM的操作数，对应一组测试数据
    wire[127:0] res;            // 存储来自模乘模块的运算结果
    reg[127:0] C_cal;           // 存储来自模乘模块的运算结果
    reg[14:0] address;          // 存储读地址
    
    assign io_A = A;
    assign io_B = B;
    assign flag = (C == C_cal)? 1'b1 : 1'b0;
    
    montgomery_multiply u_m(
        .clock(clock),
        .reset(reset),
        .io_in_valid(invalid),
        .io_A(A),
        .io_B(B),
        .io_out_valid(outvalid),
        .io_C(res)
    );
    
    datarom rom(
        .clka(~clock),      // rom的输入时钟相反
        .wea(1'b0),
        .addra(address),
        .dina(),            // 不会对rom进行写操作，挂空
        .douta(rdata)
    );
    
    // 状态机
    always@(posedge clock or posedge reset) begin
        // 初始化，模乘模块输入无效，counter置为00，访存地址指向0
        if(reset) begin
            counter <= 2'b00;
            invalid <= 1'b0;
            io_valid <= 1'b0;
            A <= 0;
            B <= 0;
            C <= 0;
            C_cal <= 0;
            address <= 0;
        end
        else begin
            case(counter)
                // 状态机00，读A，模乘模块输入无效，地址自增，准备读B
                2'b00: begin 
                        counter <= 2'b01;
                        invalid <= 1'b0;
                        io_valid <= 1'b0;
                        A <= rdata;
                        address <= address + 1;
                    end
                // 状态机01，读B，模乘模块输入无效，地址自增，准备读C
                2'b01: begin
                        counter <= 2'b10;
                        invalid <= 1'b0;
                        io_valid <= 1'b0;
                        B <= rdata;
                        address <= address + 1;
                    end
                // 状态机10，读C，模乘模块输入有效，地址自增，准备进入比较状态
                2'b10: begin
                        counter <= 2'b11;
                        invalid <= 1'b1;
                        io_valid <= 1'b0;
                        C <= rdata;
                    end
                // 状态机11，进入比较状态，模乘模块输入有效，地址不变
                
                2'b11: begin
                    // 模乘模块计算完成后重新进入读A状态，地址自增
                    if(outvalid) begin
                        counter <= 2'b00;
                        io_valid <= 1'b1;
                        C_cal <= res;
                        address <= address + 1;
                    end
                    // 否则一直等待模乘模块计算完成
                    else begin
                        counter <= 2'b11;
                        io_valid <= 1'b0;
                    end
                end
            endcase
        end
    end
        
endmodule
