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
    output reg              pass,           // 完成所有测试且不出错，置高
    output reg              fail,           // 测试中只要出错一个就置高
    output reg              done            // 完成所有测试，置高
    );
    
    reg[1:0] counter;           // 指示该次访存拿回来的数是A，B，C还是当前处于比较状态（相当于一个逻辑很简单的状态机）    
    reg invalid;                // 传到模乘模块的输入数据有效位
    wire outvalid;              // 模乘模块传来的输出数据有效位
    wire[127:0] rdata;          // 从内存取回的数    
    reg[127:0] A, B, C;         // 存储来自ROM的操作数，对应一组测试数据
    wire[127:0] res;            // 存储来自模乘模块的运算结果
    reg[14:0] address;          // 存储读地址
    
    
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
            pass <= 1'b0;
            fail <= 1'b0;
            done <= 1'b0;
            A <= 0;
            B <= 0;
            C <= 0;
            address <= 0;
        end
        else begin
            case(counter)
                // 状态机00，读A，模乘模块输入无效，地址自增，准备读B
                2'b00: begin 
                        counter <= 2'b01;
                        invalid <= 1'b0;
                        A <= rdata;
                        address <= address + 1;
                    end
                // 状态机01，读B，模乘模块输入无效，地址自增，准备读C
                2'b01: begin
                        counter <= 2'b10;
                        invalid <= 1'b0;
                        B <= rdata;
                        address <= address + 1;
                    end
                // 状态机10，读C，模乘模块输入有效，准备进入比较状态
                2'b10: begin
                        counter <= 2'b11;
                        invalid <= 1'b1;
                        C <= rdata;
                    end
                // 状态机11，进入比较状态，模乘模块输入有效，地址不变
                
                2'b11: begin
                    // 模乘模块计算完成且这是最后一组数据
                    if(outvalid == 1'b1 && address == 15'd24575) begin
                        counter <= 2'b11;
                        // 若前面失败过或者本次计算失败则将fail置高
                        fail <= fail || ~(C == res);
                        // 若之前测试向量皆通过且最后一次也通过，则将pass置高
                        pass <= ~fail && (C == res);
                        done <= 1'b1;
                    end
                    // 模乘模块计算完成后重新进入读A状态，地址自增
                    else if(outvalid == 1'b1) begin
                        counter <= 2'b00;
                        // 若前面失败过或者本次计算失败则将fail置高
                        fail <= fail || ~(C == res);
                        address <= address + 1;
                    end
                    // 否则一直等待模乘模块计算完成
                    else begin
                        counter <= 2'b11;
                    end
                end
            endcase
        end
    end
        
endmodule
