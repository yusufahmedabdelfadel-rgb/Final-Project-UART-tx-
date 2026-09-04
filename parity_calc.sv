module parity_calc (
    input  logic [7:0] data_in,
    input  logic       P_BIT,       // 0: Even, 1: Odd
    output logic       parity_bit
);
    logic xor_all;

    assign xor_all    = ^data_in;
    assign parity_bit = (P_BIT == 0) ? xor_all : ~xor_all;
endmodule
