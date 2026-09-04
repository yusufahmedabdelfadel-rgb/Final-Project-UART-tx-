module serializer (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       load_data,
    input  logic [7:0] data_in,
    input  logic       shift_en,
    output logic       serial_out
);
    logic [7:0] shift_reg;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= '0;
        end else if (load_data) begin
            shift_reg <= data_in;
        end else if (shift_en) begin
            shift_reg <= {1'b0, shift_reg[7:1]};
        end
    end

    assign serial_out = shift_reg[0];
endmodule