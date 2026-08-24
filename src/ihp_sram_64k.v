// =============================================================================
// ihp_sram_64k.v — 64 KiB SRAM subsystem for IHP SG13G2
//
// Organization:
//   16 banks x RM_IHPSG13_1P_1024x32_c2_bm_bist
//   each bank = 1024 x 32 = 4 KiB
//   total     = 16 x 4 KiB = 64 KiB
//
// Address mapping:
//   addr[13:10] : bank select (0..15)
//   addr[9:0]   : word address inside bank
//
// A_BM is an active-high per-bit write mask in the IHP behavioral model.
// The four CPU byte enables are expanded to 32 mask bits.
// BIST is disabled/tied off in this baseline integration.
// =============================================================================

`default_nettype none

(* keep_hierarchy *)
module ihp_sram_64k (
    input  wire        clk,
    input  wire        re,
    input  wire        we,
    input  wire [13:0] addr,
    input  wire [31:0] wdata,
    input  wire [ 3:0] wmask,
    output wire [31:0] rdata
);

    wire [3:0]  bank_sel = addr[13:10];
    wire [9:0]  row_addr = addr[9:0];
    wire [31:0] bit_mask = {
        {8{wmask[3]}}, {8{wmask[2]}}, {8{wmask[1]}}, {8{wmask[0]}}
    };

    wire [31:0] q00, q01, q02, q03;
    wire [31:0] q04, q05, q06, q07;
    wire [31:0] q08, q09, q10, q11;
    wire [31:0] q12, q13, q14, q15;

    // The SRAM output is registered. Capture the bank used by the read request
    // so the mux selects the matching macro output on the following cycle.
    reg [3:0] read_bank_q;
    always @(posedge clk) begin
        if (re)
            read_bank_q <= bank_sel;
    end

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank00 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd0)),
        .A_WEN       (we & (bank_sel == 4'd0)),
        .A_REN       (re & (bank_sel == 4'd0)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q00),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank01 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd1)),
        .A_WEN       (we & (bank_sel == 4'd1)),
        .A_REN       (re & (bank_sel == 4'd1)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q01),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank02 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd2)),
        .A_WEN       (we & (bank_sel == 4'd2)),
        .A_REN       (re & (bank_sel == 4'd2)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q02),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank03 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd3)),
        .A_WEN       (we & (bank_sel == 4'd3)),
        .A_REN       (re & (bank_sel == 4'd3)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q03),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank04 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd4)),
        .A_WEN       (we & (bank_sel == 4'd4)),
        .A_REN       (re & (bank_sel == 4'd4)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q04),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank05 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd5)),
        .A_WEN       (we & (bank_sel == 4'd5)),
        .A_REN       (re & (bank_sel == 4'd5)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q05),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank06 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd6)),
        .A_WEN       (we & (bank_sel == 4'd6)),
        .A_REN       (re & (bank_sel == 4'd6)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q06),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank07 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd7)),
        .A_WEN       (we & (bank_sel == 4'd7)),
        .A_REN       (re & (bank_sel == 4'd7)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q07),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank08 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd8)),
        .A_WEN       (we & (bank_sel == 4'd8)),
        .A_REN       (re & (bank_sel == 4'd8)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q08),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank09 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd9)),
        .A_WEN       (we & (bank_sel == 4'd9)),
        .A_REN       (re & (bank_sel == 4'd9)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q09),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank10 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd10)),
        .A_WEN       (we & (bank_sel == 4'd10)),
        .A_REN       (re & (bank_sel == 4'd10)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q10),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank11 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd11)),
        .A_WEN       (we & (bank_sel == 4'd11)),
        .A_REN       (re & (bank_sel == 4'd11)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q11),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank12 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd12)),
        .A_WEN       (we & (bank_sel == 4'd12)),
        .A_REN       (re & (bank_sel == 4'd12)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q12),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank13 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd13)),
        .A_WEN       (we & (bank_sel == 4'd13)),
        .A_REN       (re & (bank_sel == 4'd13)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q13),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank14 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd14)),
        .A_WEN       (we & (bank_sel == 4'd14)),
        .A_REN       (re & (bank_sel == 4'd14)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q14),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );

    RM_IHPSG13_1P_1024x32_c2_bm_bist u_bank15 (
        .A_CLK       (clk),
        .A_MEN       ((re | we) & (bank_sel == 4'd15)),
        .A_WEN       (we & (bank_sel == 4'd15)),
        .A_REN       (re & (bank_sel == 4'd15)),
        .A_ADDR      (row_addr),
        .A_DIN       (wdata),
        .A_DLY       (1'b0),
        .A_DOUT      (q15),
        .A_BM        (bit_mask),
        .A_BIST_CLK  (1'b0),
        .A_BIST_EN   (1'b0),
        .A_BIST_MEN  (1'b0),
        .A_BIST_WEN  (1'b0),
        .A_BIST_REN  (1'b0),
        .A_BIST_ADDR (10'b0),
        .A_BIST_DIN  (32'b0),
        .A_BIST_BM   (32'b0)
    );


    reg [31:0] rdata_mux;
    always @(*) begin
        case (read_bank_q)
            4'h0: rdata_mux = q00;
            4'h1: rdata_mux = q01;
            4'h2: rdata_mux = q02;
            4'h3: rdata_mux = q03;
            4'h4: rdata_mux = q04;
            4'h5: rdata_mux = q05;
            4'h6: rdata_mux = q06;
            4'h7: rdata_mux = q07;
            4'h8: rdata_mux = q08;
            4'h9: rdata_mux = q09;
            4'hA: rdata_mux = q10;
            4'hB: rdata_mux = q11;
            4'hC: rdata_mux = q12;
            4'hD: rdata_mux = q13;
            4'hE: rdata_mux = q14;
            default: rdata_mux = q15;
        endcase
    end
    assign rdata = rdata_mux;

endmodule

`default_nettype wire
