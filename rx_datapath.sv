module rx_datapath #(parameter DATA_W = 8) (
    input  logic               clk,
    input  logic               rst_n,
    input  logic               rx,
    input  logic               shift_en,
    input  logic               load_shift,
    output logic [DATA_W-1:0]  shift_reg,
    output logic [DATA_W-1:0]  o_data
);

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shift_reg <= '0;
        end else if (load_shift) begin
            shift_reg <= '0;                     
        end else if (shift_en) begin
            // إزاحة لليمين مع إدخال البت الجديد في MSB
            // بحيث يخرج LSB أولاً (حسب مواصفات UART)
            shift_reg <= {rx, shift_reg[DATA_W-1:1]};
        end
    end

    assign o_data = shift_reg;

endmodule