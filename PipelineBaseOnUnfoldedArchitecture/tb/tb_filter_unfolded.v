//`timescale 1ns

module tb_filter ();

   parameter NBIT = 12;   

   wire CLK_i;
   wire RST_n_i;
   wire [11:0] DIN3k_i;
   wire [11:0] DIN3k1_i;
   wire [11:0] DIN3k2_i;   
   wire VIN_i;
   wire [NBIT-1:0] B0_i;
   wire [NBIT-1:0] B1_i;
   wire [NBIT-1:0] B2_i;
   wire [NBIT-1:0] B3_i;
   wire [NBIT-1:0] B4_i;
   wire [NBIT-1:0] B5_i;
   wire [NBIT-1:0] B6_i;
   wire [NBIT-1:0] B7_i;
   wire [NBIT-1:0] B8_i;
   wire [NBIT-1:0] A1_i;
   wire [NBIT-1:0] A2_i;   
   wire [11:0] DOUT3k_i;
   wire [11:0] DOUT3k1_i;
   wire [11:0] DOUT3k2_i;   
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   data_maker #(.NBIT(NBIT)) SM(.CLK(CLK_i),
				.RST_n(RST_n_i),
				.vin(VOUT_i),
				.VOUT(VIN_i),
				.DOUT3k(DIN3k_i),
				.DOUT3k1(DIN3k1_i),
				.DOUT3k2(DIN3k2_i),				
				.B0(B0_i),
				.B1(B1_i),
				.B2(B2_i),
				.B3(B3_i),
				.B4(B4_i),
				.B5(B5_i),
				.B6(B6_i),
				.B7(B7_i),
				.B8(B8_i),
				.A1(A1_i),
				.A2(A2_i),
				.END_SIM(END_SIM_i));

   myfir UUT(
		.clk(CLK_i),
		.RST_n(RST_n_i),
		.din3k(DIN3k_i),
		.din3k1(DIN3k1_i),
		.din3k2(DIN3k2_i),		
		.VIN(VIN_i),
		.B0(B0_i),
		.B1(B1_i),
		.B2(B2_i),
		.B3(B3_i),
		.B4(B4_i),
		.B5(B5_i),
		.B6(B6_i),
		.B7(B7_i),
		.B8(B8_i),
		.DOUT3k(DOUT3k_i),
		.DOUT3k1(DOUT3k1_i),
		.DOUT3k2(DOUT3k2_i),		
		.VOUT(VOUT_i)
		); 

   data_sink #(.NBIT(NBIT)) DS(.CLK(CLK_i),
			       .RST_n(RST_n_i),
			       .VIN(VOUT_i),
			       .DIN3k(DOUT3k_i),
			       .DIN3k1(DOUT3k1_i),
			       .DIN3k2(DOUT3k2_i));

endmodule

		   
