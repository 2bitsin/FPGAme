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
	
		
	// Need to latch vsync/hsync because they are
	bit				lat_vsync				= 0; 
	bit				lat_hsync				= 0; 
	
	bit[9:0] 	dot_horizontal 	= 0;
	bit[8:0] 	dot_vertical 		= 0;
	
	assign 		out_clock 			= inp_clock;
	assign 		out_vsync				= lat_vsync;
	assign 		out_hsync				= lat_hsync;
	assign 		out_blank				= (dot_horizontal < DotHorizontalActive) && (dot_vertical < DotVerticalActive);
		
	assign 		out_red 				= dot_horizontal [5] ? 8'hff : 8'h00;
	assign 		out_green 			= dot_vertical [5] ? 8'h00 : 8'hff;
	assign 		out_blue				= (dot_vertical [5] ^ dot_horizontal [5]) ? 8'hff : 8'h00;
		
	always @(posedge inp_clock, negedge inp_reset)
	begin
		if (~inp_reset)
		begin
			dot_horizontal 	<= 0;
			dot_vertical		<= 0;
		end else 
		begin
			dot_horizontal <= dot_horizontal + 1;			
			if (dot_horizontal >= (DotHorizontalMax - 1))  
			begin
				dot_horizontal <= 0;	
				dot_vertical <= dot_vertical + 1;
				if (dot_vertical >= (DotVerticalMax - 1))
				begin
					dot_vertical <= 0;
				end
			end
			lat_hsync <= 0;
			lat_vsync <= 0;
			if ((dot_horizontal < DotHorSyncPulseBeg) || (dot_horizontal >= DotHorSyncPulseEnd))
				lat_hsync <= 1;
			if ((dot_vertical < DotVerSyncPulseBeg) || (dot_vertical >= DotVerSyncPulseEnd))
				lat_vsync <= 1;
			
		end
	end	

endmodule