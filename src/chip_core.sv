// =============================================================================
//  chip_core.sv — FemtoRV32 SoC core for FemtoRV32 (Quark) targeting IHP SG13G2
// =============================================================================
//  Purpose
//    Glue the single-cycle FemtoRV32 Quark CPU to a small set of on-chip
//    peripherals so that the design is meaningful in silicon (not just a bare
//    core with dangling memory wires):
//
//      Address map (Quark issues full 32-bit addresses; we decode the upper
//      bits to pick the slave):
//
//        0x0000_0000 – 0x0000_FFFF : IHP SRAM (16 × 1024 × 32 = 64 KB) program+data
//        0x1000_0000 – 0x1000_0003 : LEDs    (32-bit, write-only)
//        0x1000_0004 – 0x1000_0007 : UART TX data register
//        0x1000_0008 – 0x1000_000B : UART status / divider
//
//    The CPU drives a simple Wishbone-lite-like protocol: every cycle the
//    slave either accepts the transaction (returns busy=0) or stalls. We
//    register everything to make timing closure easier on SG13G2.
//
//  Notes
//    * FemtoRV32 Quark source (femtorv32_quark.v) must be listed BEFORE this
//      file in config.yaml so the `FemtoRV32` module is in scope.
//
//  License: MIT (matches FemtoRV32 + this wrapper)
// =============================================================================

`default_nettype none

module chip_core (
    // ---------------------------------------------------------------------
    //  External pads (driven by the chip's pad-ring when in Chip flow)
    // ---------------------------------------------------------------------
    input  wire        clk,           // system clock           (50 MHz target)
    input  wire        rst_n,         // active-low async reset

    output wire [ 3:0] led,           // 4 user LEDs
    output wire        uart_tx,       // UART transmit (115200 8N1)
    input  wire        uart_rx        // UART receive  (loopback in test)

    // No external memory bus — everything is on-chip IHP SRAM
);

    // ---------------------------------------------------------------------
    // 1)  Reset synchroniser
    // ---------------------------------------------------------------------
    reg [1:0] rst_sync;
    wire      rst = ~rst_sync[1];     // active-high reset for the core

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) rst_sync <= 2'b00;
        else        rst_sync <= {rst_sync[0], 1'b1};
    end

    // ---------------------------------------------------------------------
    // 2)  FemtoRV32 Quark core
    // ---------------------------------------------------------------------
    wire [31:0] cpu_addr;
    wire [31:0] cpu_wdata;
    wire [ 3:0] cpu_wmask;
    wire        cpu_rstrb;
    wire [31:0] cpu_rdata;
    wire        cpu_rbusy;
    wire        cpu_wbusy;

    FemtoRV32 #(
        .RESET_ADDR (32'h0000_0000),   // boot from BRAM @ 0
        .ADDR_WIDTH (24)               // 16 MB byte-addressable space
    ) u_cpu (
        .clk       (clk),
        .reset     (rst),
        .mem_addr  (cpu_addr),
        .mem_wdata (cpu_wdata),
        .mem_wmask (cpu_wmask),
        .mem_rdata (cpu_rdata),
        .mem_rstrb (cpu_rstrb),
        .mem_rbusy (cpu_rbusy),
        .mem_wbusy (cpu_wbusy)
    );

    // ---------------------------------------------------------------------
    // 3)  Address decode
    // ---------------------------------------------------------------------
    wire bram_sel = (cpu_addr[31:16] == 16'h0000);
    wire led_sel  = (cpu_addr[31: 2] == 30'h0400_0000);   // 0x1000_0000
    wire utx_sel  = (cpu_addr[31: 2] == 30'h0400_0001);   // 0x1000_0004
    wire ust_sel  = (cpu_addr[31: 2] == 30'h0400_0002);   // 0x1000_0008

    // ---------------------------------------------------------------------
    // 4)  IHP SG13G2 SRAM (16 banks × 1024 × 32 = 64 KB)
    // ---------------------------------------------------------------------
    wire        sram_we    = bram_sel & (|cpu_wmask);
    wire        sram_re    = bram_sel & cpu_rstrb;
    wire [13:0] sram_addr  = cpu_addr[15:2];       // 16 K word index
    wire [31:0] sram_wdata = cpu_wdata;
    wire [ 3:0] sram_wmask = cpu_wmask;
    wire [31:0] sram_rdata;

ihp_sram_64k u_sram (
    .clk   (clk),
    .re    (sram_re),
    .we    (sram_we),
    .addr  (sram_addr),
    .wdata (sram_wdata),
    .wmask (sram_wmask),
    .rdata (sram_rdata)
);

    // ---------------------------------------------------------------------
    // 5)  LED register
    // ---------------------------------------------------------------------
    reg  [31:0] led_reg;
    wire        led_wr = led_sel & |cpu_wmask;
    always @(posedge clk or posedge rst) begin
        if (rst)    led_reg <= 32'h0;
        else if (led_wr) led_reg <= cpu_wdata;
    end
    assign led = led_reg[3:0];

    // ---------------------------------------------------------------------
    // 6)  Minimal UART (115200 8N1)
    //     Divider assumes clk = 50 MHz → 50e6 / 115200 ≈ 434.
    // ---------------------------------------------------------------------
    reg  [31:0] utx_shift;
    reg  [ 9:0] utx_divider;
    reg  [ 3:0] utx_bitcnt;
    reg         utx_active;
    reg         utx_reg;

    wire        utx_wr = utx_sel & |cpu_wmask;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            utx_shift  <= 32'h0;
            utx_divider<= 10'd0;
            utx_bitcnt <= 4'd0;
            utx_active <= 1'b0;
            utx_reg    <= 1'b1;        // idle line = '1'
        end else begin
            if (utx_wr && !utx_active) begin
                utx_shift   <= {1'b1, cpu_wdata[7:0], 1'b0}; // start + data + stop
                utx_bitcnt  <= 4'd10;
                utx_divider <= 10'd0;
                utx_active  <= 1'b1;
            end else if (utx_active) begin
                if (utx_divider == 10'd433) begin
                    utx_divider <= 10'd0;
                    utx_reg     <= utx_shift[0];
                    utx_shift   <= {1'b0, utx_shift[9:1]};
                    utx_bitcnt  <= utx_bitcnt - 4'd1;
                    if (utx_bitcnt == 4'd1) utx_active <= 1'b0;
                end else begin
                    utx_divider <= utx_divider + 10'd1;
                end
            end
        end
    end
    assign uart_tx = utx_reg;
    // uart_rx currently unused — left as a stub for future echo.
    // (libre lane will not complain about unused input when WIRED_INPUTS warnings
    // are kept at default.)

    // ---------------------------------------------------------------------
    // 7)  Slave read mux + busy back to CPU
    // ---------------------------------------------------------------------
    reg [31:0] rdata_r;
    reg        rbusy_r;

    always @(*) begin
        rdata_r  = 32'h0;
        rbusy_r  = 1'b0;
        if (bram_sel) begin
            rdata_r = sram_rdata;
        end else if (led_sel) begin
            rdata_r = led_reg;
        end else if (utx_sel) begin
            rdata_r = {31'd0, utx_active};
        end else if (ust_sel) begin
            rdata_r = 32'h0;          // divider not implemented
        end
    end

    assign cpu_rdata = rdata_r;
    assign cpu_rbusy = rbusy_r;       // everything is single-cycle → always 0
    assign cpu_wbusy = 1'b0;

    // Suppress 'rstrb' warning — we keep it for protocol symmetry
    wire _unused_ok = &{1'b0, cpu_rstrb, 1'b0};

endmodule

`default_nettype wire
