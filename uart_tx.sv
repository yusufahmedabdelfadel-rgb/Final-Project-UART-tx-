module uart_tx #(parameter DATA_W = 8) (
    input  logic               i_clk,
    input  logic               i_rst_n,
    input  logic [DATA_W-1:0]  i_data,
    input  logic               i_valid,
    input  logic               i_par_en,
    input  logic               i_par_odd,
    output logic               o_busy,
    output logic               o_tx
);
    logic       load_data, shift_en, serial_out, parity_bit;
    logic [2:0] state;

    control ctrl (
        .clk      (i_clk),
        .rst_n    (i_rst_n),
        .V_INPUT  (i_valid),
        .P_EN     (i_par_en),
        .busy     (o_busy),
        .load_data(load_data),
        .shift_en (shift_en),
        .state    (state)
    );

    serializer ser (
        .clk       (i_clk),
        .rst_n     (i_rst_n),
        .load_data (load_data),
        .data_in   (i_data),
        .shift_en  (shift_en),
        .serial_out(serial_out)
    );

    parity_calc pc (
        .data_in   (i_data),
        .P_BIT     (i_par_odd),
        .parity_bit(parity_bit)
    );

    mux mux_inst (
        .state     (state),
        .serial_out(serial_out),
        .parity_bit(parity_bit),
        .TX_OUT    (o_tx)
    );
endmodule