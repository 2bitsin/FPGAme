module video (
	input		wire			inp_clock,
	input 	wire			inp_reset,
	
	output 	wire[7:0] out_red,
	output 	wire[7:0] out_green,
	output 	wire[7:0] out_blue,
	output 	wire 			out_hsync,
	output 	wire			out_vsync,
	output 	wire 			out_blank,
	output 	wire 			out_clock);

	localparam shortint DotHorizontalMax 		= 800;
	localparam shortint DotVerticalMax 			= 525;	
	localparam shortint DotHorizontalActive	= 640;
	localparam shortint DotVerticalActive		= 480;	
	localparam shortint	DotHorFrontPorch		= 16;
	localparam shortint	DotHorBackPorch			= 48;	
	localparam shortint	DotHorSyncPulse			= 96;	
	localparam shortint	DotVerFrontPorch		= 11;
	localparam shortint	DotVerBackPorch			= 31;	
	localparam shortint	DotVerSyncPulse			= 2;	
	localparam shortint DotHorSyncPulseBeg	= DotHorizontalActive + DotHorFrontPorch;
	localparam shortint DotHorSyncPulseEnd	= DotHorizontalActive + DotHorFrontPorch + DotHorSyncPulse;
	localparam shortint DotVerSyncPulseBeg	= DotVerticalActive + DotVerFrontPorch;
	localparam shortint DotVerSyncPulseEnd	= DotVerticalActive + DotVerFrontPorch + DotVerSyncPulse;
		
	assign out_red   = 0;
	assign out_green = 0;
	assign out_blue  = 0;
	assign out_hsync = 1;
	assign out_vsync = 1;
	assign out_blank = 0;
	assign out_clock = inp_clock;

endmodule