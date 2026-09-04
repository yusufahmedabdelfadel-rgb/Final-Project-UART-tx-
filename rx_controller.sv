module rx_controller #(parameter DATA_W = 8) (
    input  logic          clk,
    input  logic          rst_n,
    input  logic          rx,
    input  logic          par_en,
    input  logic          parity_expected,
    output logic          shift_en,
    output logic          load_shift,
    output logic          busy,
    output logic          valid,
    output logic          frame_err,
    output logic          parity_err
);

    typedef enum logic [2:0] {
        IDLE,
        START,
        DATA,
        PARITY,
        STOP
    } state_t;

    state_t state, next_state;
    logic [2:0] bit_cnt;        
    logic parity_err_reg;       

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state          <= IDLE;
            bit_cnt        <= 3'd0;
            parity_err_reg <= 1'b0;
        end else begin
            state <= next_state;

            if (state == DATA) begin
                if (bit_cnt == DATA_W - 1)
                    bit_cnt <= 3'd0;
                else
                    bit_cnt <= bit_cnt + 1'b1;
            end else if (state == IDLE && rx == 1'b0) begin
                bit_cnt <= 3'd0;
            end

            if (state == PARITY) begin
                parity_err_reg <= (parity_expected != rx);
            end else if (state == IDLE) begin
                parity_err_reg <= 1'b0;
            end
        end
    end

    always_comb begin
        // القيم الافتراضية
        shift_en   = 1'b0;
        load_shift = 1'b0;
        busy       = 1'b0;
        valid      = 1'b0;
        frame_err  = 1'b0;
        parity_err = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                busy = 1'b0;
                if (rx == 1'b0) begin           
                    next_state = START;
                    load_shift = 1'b1;          
                    busy = 1'b1;
                end
            end

            START: begin
                busy = 1'b1;
                if (rx == 1'b0)
                    next_state = DATA;          
                else
                    next_state = IDLE;          
            end

            DATA: begin
                busy     = 1'b1;
                shift_en = 1'b1;                
                if (bit_cnt == DATA_W - 1) begin
                    if (par_en)
                        next_state = PARITY;
                    else
                        next_state = STOP;
                end
            end

            PARITY: begin
                busy = 1'b1;
                next_state = STOP;
            end

            STOP: begin
                busy      = 1'b0;
                valid     = 1'b1;               
                frame_err = (rx != 1'b1);       
                parity_err = parity_err_reg;    
                next_state = IDLE;
            end
        endcase
    end

endmodule
