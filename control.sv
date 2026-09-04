typedef enum logic [2:0] {
    STEP0 = 3'd0,
    STEP1 = 3'd1,
    STEP2 = 3'd2,
    STEP3 = 3'd3,
    STEP4 = 3'd4
} state_t;

module control (
    input  logic       clk,
    input  logic       rst_n,
    input  logic       V_INPUT,
    input  logic       P_EN,
    output logic       busy,
    output logic       load_data,
    output logic       shift_en,
    output state_t     state   
);

    state_t cur_state;
    logic [2:0] bit_count;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_state  <= STEP0;
            busy       <= 1'b0;
            load_data  <= 1'b0;
            shift_en   <= 1'b0;
            bit_count  <= 3'd0;
        end else begin
            load_data <= 1'b0;
            shift_en  <= 1'b0;

            case (cur_state)
                STEP0: begin
                    if (V_INPUT) begin
                        cur_state <= STEP1;
                        busy      <= 1'b1;
                        load_data <= 1'b1;
                        bit_count <= 3'd0;
                    end
                end

                STEP1: begin
                    cur_state <= STEP2;
                end

                STEP2: begin
                    shift_en <= 1'b1;
                    if (bit_count == 3'd7) begin
                        if (P_EN)
                            cur_state <= STEP3;
                        else
                            cur_state <= STEP4;
                        bit_count <= 3'd0;
                    end else begin
                        bit_count <= bit_count + 1'b1;
                    end
                end

                STEP3: begin
                    cur_state <= STEP4;
                end

                STEP4: begin
                    cur_state <= STEP0;
                    busy      <= 1'b0;
                end

                default: cur_state <= STEP0;
            endcase
        end
    end

    assign state = cur_state;

endmodule