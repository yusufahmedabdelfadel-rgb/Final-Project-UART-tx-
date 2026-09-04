module mux (
    input  logic [2:0] state,
    input  logic       serial_out,
    input  logic       parity_bit,
    output logic       TX_OUT
);
    always_comb begin
        case (state)
            3'd0: TX_OUT = 1'b1;
            3'd1: TX_OUT = 1'b0;
            3'd2: TX_OUT = serial_out;
            3'd3: TX_OUT = parity_bit;
            3'd4: TX_OUT = 1'b1;
            default: TX_OUT = 1'b1;
        endcase
    end
endmodule
