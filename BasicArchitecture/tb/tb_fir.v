//`timescale 1ns

module tb_fir ();

   wire CLK_i;
   wire RST_n_i;
   wire [11:0] DIN_i;
   wire VIN_i;
   wire [11:0] B0_i;
   wire [11:0] B1_i;
   wire [11:0] B2_i;
   wire [11:0] B3_i;
   wire [11:0] B4_i;
   wire [11:0] B5_i;
   wire [11:0] B6_i;
   wire [11:0] B7_i;
   wire [11:0] B8_i;           
   wire [11:0] DOUT_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .clk(CLK_i),
	      .RST_n(RST_n_i));
//.xx is the componnet port name, .xx(binding wire )
   data_maker SM(
		.clk(CLK_i),
		.RST_n(RST_n_i),
		.VOUT(VIN_i),//1
		.DOUT(DIN_i),//--16
		.B0(B0_i),
		.B1(B1_i),
		.B2(B2_i),
		.B3(B3_i),
		.B4(B4_i),
		.B5(B5_i),
		.B6(B6_i),
		.B7(B7_i),
		.B8(B8_i),
		.END_SIM(END_SIM_i));//1

   myfir UUT(.clk(CLK_i),
				.RST_n(RST_n_i),
				.din(DIN_i),//16
				.VIN(VIN_i),//1
				.B0(B0_i),//16
				.B1(B1_i),//16
				.B2(B2_i),//16
				.B3(B3_i),//16
				.B4(B4_i),//16
				.B5(B5_i),//16
				.B6(B6_i),//16
				.B7(B7_i),//16
				.B8(B8_i),//16
				.DOUT(DOUT_i),//16
				.VOUT(VOUT_i));//1

   data_sink DS(
		.clk(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i)
		);   

endmodule

		   
