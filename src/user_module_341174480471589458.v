/*
 * user_module_341174480471589458.v
 */

`default_nettype none

module user_module_341174480471589458 (
	input  wire        latch_in,
	input  wire  [7:0] io_in,
	output wire  [7:0] io_out
);

	// Signals
	// -------

	// IO extension
	wire [31:0] eio_in;
	wire [31:0] eio_out;
	wire  [7:0] eio_latch_n;

	wire        clk_slow;
	wire        clk_fast;


	// IO extension
	// ------------

	// Input 0 is slow clock, keep as-is
	sky130_fd_sc_hd__dlxtp_1 in_clk_slow_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.D    (io_in[0]),
		.GATE (latch_in),
		.Q    (clk_slow)
	);

	// Input [3:1] is 'address'
		// Group 0
	sky130_fd_sc_hd__or4b_1 in_dec_0_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (io_in[1]),
		.B    (io_in[2]),
		.C    (io_in[3]),
		.D_N  (latch_in),
		.X    (eio_latch_n[0])
	);

		// Group 1
	sky130_fd_sc_hd__nand4bb_1 in_dec_1_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[3]),
		.B_N  (io_in[2]),
		.C    (io_in[1]),
		.D    (latch_in),
		.Y    (eio_latch_n[1])
	);

		// Group 2
	sky130_fd_sc_hd__nand4bb_1 in_dec_2_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[3]),
		.B_N  (io_in[1]),
		.C    (io_in[2]),
		.D    (latch_in),
		.Y    (eio_latch_n[2])
	);

		// Group 3
	sky130_fd_sc_hd__nand4b_1 in_dec_3_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[3]),
		.B    (io_in[2]),
		.C    (io_in[1]),
		.D    (latch_in),
		.Y    (eio_latch_n[3])
	);

		// Group 4
	sky130_fd_sc_hd__nand4bb_1 in_dec_4_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[1]),
		.B_N  (io_in[2]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[4])
	);

		// Group 5
	sky130_fd_sc_hd__nand4b_1 in_dec_5_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[2]),
		.B    (io_in[1]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[5])
	);

		// Group 6
	sky130_fd_sc_hd__nand4b_1 in_dec_6_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A_N  (io_in[1]),
		.B    (io_in[2]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[6])
	);

		// Group 7
	sky130_fd_sc_hd__nand4_1 in_dec_7_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (io_in[1]),
		.B    (io_in[2]),
		.C    (io_in[3]),
		.D    (latch_in),
		.Y    (eio_latch_n[7])
	);

	// Input [7:4] is data
	genvar i;
	generate
		for (i=0; i<8; i=i+1) begin
			sky130_fd_sc_hd__dlxtn_1 in_latch_I[3:0] (
`ifdef WITH_POWER
				.VPWR (1'b1),
				.VGND (1'b0),
`endif
				.D      (io_in[7:4]),
				.GATE_N (eio_latch_n[i]),
				.Q      (eio_in[i*4+:4])
			);
		end
	endgenerate

	// Output mux
	sky130_fd_sc_hd__mux4_1 out_mux_I[7:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A0   (eio_out[ 7: 0]),
		.A1   (eio_out[15: 8]),
		.A2   (eio_out[23:16]),
		.A3   (eio_out[31:24]),
		.X    (io_out),
		.S0   (eio_in[0]),
		.S1   (eio_in[1])
	);


	// Ring oscillator
	// ---------------

	// Signals
	wire  [1:0] osc_ctrl;
	wire [17:0] osc_chain;
	wire [16:0] osc_chain_dly;
	wire        osc_mux;
	wire        osc_out;

	// IOs
	assign osc_ctrl = eio_in[5:4];

	// Chain
		// First
	assign osc_chain[0] = osc_out;

		// Delay
	sky130_fd_sc_hd__clkdlybuf4s50_1 osc_dly_I[16:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (osc_chain[16:0]),
		.X    (osc_chain_dly)
	);

		// Inverter
	sky130_fd_sc_hd__clkinv_1 osc_inv_I[16:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (osc_chain_dly),
		.Y    (osc_chain[17:1])
	);

	// Feedback mux
	sky130_fd_sc_hd__mux4_1 osc_mux_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A0   (1'b0),
		.A1   (osc_chain[17]),
		.A2   (osc_chain[9]),
		.A3   (osc_chain[5]),
		.X    (osc_mux),
		.S0   (osc_ctrl[0]),
		.S1   (osc_ctrl[1])
	);

	// Output buffer
	sky130_fd_sc_hd__clkbuf_2 osc_buf_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (osc_mux),
		.X    (osc_out)
	);


	// Clock divider
	// -------------
	// Should support 1:1 / 1:4 / 1:16 / 1:64

	// Signals
	wire  [1:0] clk_div_ctrl;
	wire  [6:0] clk_div_chain;
	wire  [6:0] clk_div_chain_n;
	wire        clk_div_mux;

	// IOs
	assign clk_div_ctrl = eio_in[7:6];

	// Input
	assign clk_div_chain[0] = osc_out;

	// 6 stages of divide-by-2
	generate
		for (i=1; i<7; i=i+1)
		begin
			sky130_fd_sc_hd__inv_1 clk_div_inv_I (
`ifdef WITH_POWER
				.VPWR (1'b1),
				.VGND (1'b0),
`endif
				.A    (clk_div_chain[i]),
				.Y    (clk_div_chain_n[i])
			);

			sky130_fd_sc_hd__dfxtp_1 clk_div_reg_I (
`ifdef WITH_POWER
				.VPWR (1'b1),
				.VGND (1'b0),
`endif
				.D    (clk_div_chain_n[i]),
				.Q    (clk_div_chain[i]),
				.CLK  (clk_div_chain[i-1])
			);
		end
	endgenerate

	// Output select
	sky130_fd_sc_hd__mux4_1 clk_div_mux_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A0   (clk_div_chain[0]),
		.A1   (clk_div_chain[2]),
		.A2   (clk_div_chain[4]),
		.A3   (clk_div_chain[6]),
		.X    (clk_div_mux),
		.S0   (clk_div_ctrl[0]),
		.S1   (clk_div_ctrl[1])
	);

	// Output buffer
	sky130_fd_sc_hd__clkbuf_8 clk_div_buf_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (clk_div_mux),
		.X    (clk_fast)
	);


	// 16 bits LFSR
	// ------------

	// Signals
	wire  [3:0] lfsr_ctrl;

	wire        lfsr_clk_mux;
	wire        lfsr_clk_gate;
	wire        lfsr_clk_buf;

	wire [15:0] lfsr_in;
	wire [15:0] lfsr_out;
	wire  [2:0] lfsr_xor;
	wire        lfsr_init;

	// I/O
	assign lfsr_ctrl = eio_in[11:8];
	assign eio_out[31:16] = lfsr_out;

	// Clock mux & enable
	sky130_fd_sc_hd__mux2_1 lfsr_clk_mux_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A0   (clk_slow),
		.A1   (clk_fast),
		.S    (lfsr_ctrl[2]),
		.X    (lfsr_clk_mux)
	);

	sky130_fd_sc_hd__and2_1 lfsr_clk_gate_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (lfsr_ctrl[3]),
		.B    (lfsr_clk_mux),
		.X    (lfsr_clk_gate)
	);

	sky130_fd_sc_hd__clkbuf_8 lfsr_clk_buf_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    (lfsr_clk_gate),
		.X    (lfsr_clk_buf)
	);

	// Input mapping
	assign lfsr_in = {
		lfsr_init,
		lfsr_out[15],
		lfsr_xor[2:1],
		lfsr_out[12],
		lfsr_xor[0],
		lfsr_out[10:1]
	};

	// Registers
	sky130_fd_sc_hd__dfxtp_1 lfsr_reg_I[15:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.D    (lfsr_in),
		.Q    (lfsr_out),
		.CLK  (lfsr_clk_buf)
	);

	// XORs
	sky130_fd_sc_hd__xor2_1 lfsr_xor_I[2:0] (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A    ({lfsr_out[14], lfsr_out[13], lfsr_out[11]}),
		.B    (lfsr_out[0]),
		.X    (lfsr_xor)
	);

	// Init
	sky130_fd_sc_hd__mux2_1 lfsr_init_I (
`ifdef WITH_POWER
		.VPWR (1'b1),
		.VGND (1'b0),
`endif
		.A0   (lfsr_out[0]),
		.A1   (lfsr_ctrl[0]),
		.S    (lfsr_ctrl[1]),
		.X    (lfsr_init)
	);


	// Dummy
	// -----

	// Just link in/output
	assign eio_out[15:0] = eio_in[15:0];

endmodule // user_module_341174480471589458
