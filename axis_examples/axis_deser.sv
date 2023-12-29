`timescale 1ns/1ps

module axis_deser #(
    parameter AXIS_NUM_BYTES   = 4,
    parameter TMP_BUFFER_WORDS = 512,
    parameter RAM_WIDTH        = 32
) (
    input clk,
    input rstn,
    // AXI stream master interface
    output logic tvalid_o,
    output logic tlast_o,
    input  logic tready_i,
    output logic [AXIS_NUM_BYTES-1:0] tkeep_o,
    output logic [AXIS_NUM_BYTES*8-1:0] tdata_o,
    output logic tuser_o,

    input [31:0] words_in_packet_i,
    input [31:0] axis_package_sz_i,

    input serial_i,
    input serial_valid_i
);
    localparam SHFT_CNT_LEN = $clog2(AXIS_NUM_BYTES*8);
    // Hom many axis packets to send
    localparam AXIS_CNT_LEN = $clog2(TMP_BUFFER_WORDS);

    // Receive FSM states
    localparam RECV            = 1;
    localparam WAIT_PACKET_END = 2;
    localparam AXIS_SEND       = 3;
    localparam RESET           = 4;

    logic [3:0] fsm_state;

    // Regs for Recv part
    logic [AXIS_NUM_BYTES*8-1:0] data_shft_r;
    logic [SHFT_CNT_LEN-1:0]     shft_cnt;
    logic [31:0]                 recv_pack_cnt;

    // Regs for AXIS part
    logic [AXIS_CNT_LEN-1:0] ram_r_buffer_ptr;
    logic [AXIS_CNT_LEN-1:0] ram_w_buffer_ptr;
    logic buffer_we;

    logic [31:0] idx_cnt;
    logic return_prev_word;
    logic packet_in_progress;

    bram #(
        .RAM_WIDTH(RAM_WIDTH),
        .RAM_DEPTH(TMP_BUFFER_WORDS)
    ) bram_i (
        .clka(clk),

        .addra(ram_w_buffer_ptr),
        .addrb(ram_r_buffer_ptr),
        .dina(data_shft_r),
        .doutb(tdata_o),

        .wea(buffer_we)
    );

    always_ff @(posedge clk, negedge rstn) begin
        if(!rstn) begin
            data_shft_r   <= 0;
            recv_pack_cnt <= 0;
            shft_cnt      <= AXIS_NUM_BYTES*8-1;
            fsm_state     <= RECV;

            ram_w_buffer_ptr <= 0;
            ram_r_buffer_ptr <= 1;
            buffer_we        <= 0;

            tvalid_o <= 0;
            tlast_o  <= 0;
            tkeep_o  <= {AXIS_NUM_BYTES{1'b1}};
            tuser_o  <= 0;

            return_prev_word <= 0;
            idx_cnt          <= 0;
        end else begin
            case (fsm_state)
                RECV: begin
                    if(serial_valid_i) begin
                        data_shft_r <= { data_shft_r[AXIS_NUM_BYTES*8-2:0], serial_i };
                        shft_cnt    <= (shft_cnt == 0) ? AXIS_NUM_BYTES*8-1 : shft_cnt - 1;
                    end

                    if(shft_cnt == 0 && serial_valid_i) begin
                        recv_pack_cnt    <= ( recv_pack_cnt == words_in_packet_i - 1 ) ? 0 : recv_pack_cnt + 1;
                        ram_w_buffer_ptr <= ram_w_buffer_ptr + 1;
                        buffer_we        <= 1;

                        if (recv_pack_cnt >= words_in_packet_i - 1) begin
                            fsm_state  <= AXIS_SEND;
                        end
                    end else begin
                        buffer_we <= 0;
                    end
                end
                AXIS_SEND: begin
                    if (tready_i) begin
                        return_prev_word <= 1;
                        ram_r_buffer_ptr <= ram_r_buffer_ptr + 1;
                        tvalid_o         <= 1;

                        if (ram_r_buffer_ptr >= (axis_package_sz_i - 1)) begin
                            tlast_o   <= 1;
                            fsm_state <= WAIT_PACKET_END;
                            idx_cnt   <= idx_cnt + 1;
                        end else begin
                            tlast_o <= 0;
                        end
                    end else begin
                        tvalid_o <= 0;
                        if (return_prev_word) begin
                            ram_r_buffer_ptr <= ram_r_buffer_ptr - 1;
                            return_prev_word <= 0;
                        end
                    end
                end
                WAIT_PACKET_END: begin
                    tvalid_o  <= 0;
                    tlast_o   <= 1;
                    fsm_state <= packet_in_progress ? WAIT_PACKET_END : RESET;
                end
                RESET: begin
                    fsm_state     <= RECV;
                    recv_pack_cnt <= 0;

                    ram_w_buffer_ptr <= 0;
                    ram_r_buffer_ptr <= 1;

                    tvalid_o <= 0;
                    tlast_o  <= 1;
                end
           endcase
        end
    end
endmodule
