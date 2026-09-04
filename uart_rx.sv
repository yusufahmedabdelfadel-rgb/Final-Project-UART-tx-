module uart_rx #(parameter DATA_W = 8) (
    input  logic               i_clk,
    input  logic               i_rst_n,
    input  logic               i_rx,
    input  logic               i_par_en,
    input  logic               i_par_odd,
    output logic [DATA_W-1:0]  o_data,
    output logic               o_valid,
    output logic               o_busy,
    output logic               o_parity_err,
    output logic               o_frame_err
);
    // ... نفس الوحدات الفرعية السابقة (rx_controller, rx_datapath, rx_parity)
    // يجب أن تكون هذه الوحدات الفرعية معرفة في ملفات منفصلة أو ضمن نفس الملف.
    // نضع هنا فقط instantiation كما في السابق.
    logic               shift_en;
    logic               load_shift;
    logic [DATA_W-1:0]  shift_reg;
    logic               parity_expected;

    rx_controller #(.DATA_W(DATA_W)) ctrl (
        .clk             (i_clk),
        .rst_n           (i_rst_n),
        .rx              (i_rx),
        .par_en          (i_par_en),
        .parity_expected (parity_expected),
        .shift_en        (shift_en),
        .load_shift      (load_shift),
        .busy            (o_busy),
        .valid           (o_valid),
        .frame_err       (o_frame_err),
        .parity_err      (o_parity_err)
    );

    rx_datapath #(.DATA_W(DATA_W)) dp (
        .clk       (i_clk),
        .rst_n     (i_rst_n),
        .rx        (i_rx),
        .shift_en  (shift_en),
        .load_shift(load_shift),
        .shift_reg (shift_reg),
        .o_data    (o_data)
    );

    rx_parity #(.DATA_W(DATA_W)) par (
        .data_in   (shift_reg),
        .par_odd   (i_par_odd),
        .parity_out(parity_expected)
    );
endmodule