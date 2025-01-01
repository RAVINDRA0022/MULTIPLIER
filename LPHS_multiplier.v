module multiplier(
    input [3:0] A, 
    input [3:0] B, 
    output [7:0] Product 
);
    
    wire [1:0] QA1, QA2, QB1, QB2; 
    wire [7:0] PP1, PP2, PP3, PP4;  
    wire [7:0] S1, S2, S3;
    wire C1, C2, C3;

    QuaternaryEncoder encA1 (.bin(A[3:2]), .quaternary(QA1));
    QuaternaryEncoder encA2 (.bin(A[1:0]), .quaternary(QA2));
    QuaternaryEncoder encB1 (.bin(B[3:2]), .quaternary(QB1));
    QuaternaryEncoder encB2 (.bin(B[1:0]), .quaternary(QB2));

    PartialProduct pp1 (.A(QA1), .B(QB1), .PP(PP1));
    PartialProduct pp2 (.A(QA1), .B(QB2), .PP(PP2));
    PartialProduct pp3 (.A(QA2), .B(QB1), .PP(PP3));
    PartialProduct pp4 (.A(QA2), .B(QB2), .PP(PP4));

    QCLA qcla1 (.A(PP1[3:0]), .B(PP2[3:0]), .Cin(0), .Sum(S1[3:0]), .Cout(C1));
    QCLA qcla2 (.A(S1[3:0]), .B(PP3[3:0]), .Cin(C1), .Sum(S2[3:0]), .Cout(C2));
    QCLA qcla3 (.A(S2[3:0]), .B(PP4[3:0]), .Cin(C2), .Sum(S3[3:0]), .Cout(C3));

    assign Product = {C3, S3[3:0]}; 
endmodule

module QuaternaryEncoder(input [1:0] bin, output reg [1:0] quaternary);
    always @(*) begin
        case (bin)
            2'b00: quaternary = 2'b00;
            2'b01: quaternary = 2'b01;
            2'b10: quaternary = 2'b10;
            2'b11: quaternary = 2'b11;
            default: quaternary = 2'b00; 
        endcase
    end
endmodule

module QuaternaryDecoder(input [3:0] quaternary, output reg [7:0] bin);
    always @(*) begin
        case (quaternary)
            4'b0000: bin = 8'b00000000;
            4'b0001: bin = 8'b00000001;
            4'b0010: bin = 8'b00000010;
            4'b0011: bin = 8'b00000011;
            4'b0100: bin = 8'b00000100;
            4'b0101: bin = 8'b00000101;
            4'b0110: bin = 8'b00000110;
            4'b0111: bin = 8'b00000111;
            4'b1000: bin = 8'b00001000;
            4'b1001: bin = 8'b00001001;
            4'b1010: bin = 8'b00001010;
            4'b1011: bin = 8'b00001011;
            4'b1100: bin = 8'b00001100;
            4'b1101: bin = 8'b00001101;
            4'b1110: bin = 8'b00001110;
            4'b1111: bin = 8'b00001111;
            default: bin = 8'bxxxxxxxx; // Invalid case
        endcase
    end
endmodule

module QCLA(input [3:0] A, input [3:0] B, input Cin, output [3:0] Sum, output Cout);
    wire [3:0] G, P, Carry;

    assign G = A & B;   // Generate
    assign P = A | B;   // Propagate
    assign Carry = G | (P & {4{Cin}}); // Carry logic
    assign Cout = Carry[3];
    assign Sum = A + B + Cin;                         
endmodule

module PartialProduct(input [1:0] A, input [1:0] B, output [7:0] PP);

    assign PP = A * B;
endmodule
