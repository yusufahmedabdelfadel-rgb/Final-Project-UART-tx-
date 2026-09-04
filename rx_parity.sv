module rx_parity #(parameter DATA_W = 8) (
    input  logic [DATA_W-1:0] data_in,
    input  logic              par_odd,      // 0: Even, 1: Odd
    output logic              parity_out
);

    logic xor_all;

    assign xor_all   = ^data_in;            // Even parity of data bits
    assign parity_out = (par_odd == 1'b0) ? xor_all : ~xor_all;

endmodule