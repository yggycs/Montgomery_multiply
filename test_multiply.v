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
    input                   clock,          // ʱ���ź�
    input                   reset,          // ��λ�źţ��ߵ�ƽ��Ч
    output [127:0]          io_A,           // ������A
    output [127:0]          io_B,           // ������B
    output reg              io_valid,       // ָʾ�ô������Ƿ���Ч
    output                  flag            // �жϽ���Ƿ���ȷ������ȷ������ߵ�ƽ
    );
    
    reg[1:0] counter;           // ָʾ�ôηô��û���������A��B��C���ǵ�ǰ���ڱȽ�״̬���൱��һ���߼��ܼ򵥵�״̬����    
    reg invalid;                // ����ģ��ģ�������������Чλ
    wire outvalid;              // ģ��ģ�鴫�������������Чλ
    wire[127:0] rdata;          // ���ڴ�ȡ�ص���    
    reg[127:0] A, B, C;         // �洢����ROM�Ĳ���������Ӧһ���������
    wire[127:0] res;            // �洢����ģ��ģ���������
    reg[127:0] C_cal;           // �洢����ģ��ģ���������
    reg[14:0] address;          // �洢����ַ
    
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
        .clka(~clock),      // rom������ʱ���෴
        .wea(1'b0),
        .addra(address),
        .dina(),            // �����rom����д�������ҿ�
        .douta(rdata)
    );
    
    // ״̬��
    always@(posedge clock or posedge reset) begin
        // ��ʼ����ģ��ģ��������Ч��counter��Ϊ00���ô��ַָ��0
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
                // ״̬��00����A��ģ��ģ��������Ч����ַ������׼����B
                2'b00: begin 
                        counter <= 2'b01;
                        invalid <= 1'b0;
                        io_valid <= 1'b0;
                        A <= rdata;
                        address <= address + 1;
                    end
                // ״̬��01����B��ģ��ģ��������Ч����ַ������׼����C
                2'b01: begin
                        counter <= 2'b10;
                        invalid <= 1'b0;
                        io_valid <= 1'b0;
                        B <= rdata;
                        address <= address + 1;
                    end
                // ״̬��10����C��ģ��ģ��������Ч����ַ������׼������Ƚ�״̬
                2'b10: begin
                        counter <= 2'b11;
                        invalid <= 1'b1;
                        io_valid <= 1'b0;
                        C <= rdata;
                    end
                // ״̬��11������Ƚ�״̬��ģ��ģ��������Ч����ַ����
                
                2'b11: begin
                    // ģ��ģ�������ɺ����½����A״̬����ַ����
                    if(outvalid) begin
                        counter <= 2'b00;
                        io_valid <= 1'b1;
                        C_cal <= res;
                        address <= address + 1;
                    end
                    // ����һֱ�ȴ�ģ��ģ��������
                    else begin
                        counter <= 2'b11;
                        io_valid <= 1'b0;
                    end
                end
            endcase
        end
    end
        
endmodule