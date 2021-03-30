
module video (
	input		wire			clock,
	input 	wire			reset,
	
	output 	wire[7:0] out_red,
	output 	wire[7:0] out_green,
	output 	wire[7:0] out_blue,
	output 	wire 			out_hsync,
	output 	wire			out_vsync,
	output 	wire 			out_blank,
	output 	wire 			out_clock);

	
	localparam G_active_h = 256;
	localparam G_active_v = 240;
	
	localparam G_front_h 	= 9;
	localparam G_sync_h 	= 51;
	localparam G_back_h 	= 25;

	localparam G_front_v 	= 5;
	localparam G_sync_v 	= 1;
	localparam G_back_v 	= 16;

	localparam G_blank_h  = G_front_h + G_sync_h + G_back_h;
	localparam G_blank_v 	= G_front_v + G_sync_v + G_back_v;
	
	localparam G_ticks_h 	= G_active_h + G_blank_h;
	localparam G_ticks_v	= G_active_v + G_blank_v;		
	
	bit[15:0] 	counter_v	= 0;
	bit[15:0] 	counter_h	= 0;	
	bit 				lat_hsync = 0;
	bit 				lat_vsync = 0; 
		
	assign 			out_hsync 	= lat_hsync;
	assign 			out_vsync 	= lat_vsync;
	assign 			out_clock 	= clock;
	assign 			out_blank 	= counter_v >= G_blank_v && counter_h >= G_blank_h;
	
	localparam 	delay = 2;
	
	wire[7:0]		idx_h  	= counter_h >= G_blank_h - delay ? counter_h - G_blank_h + delay : 0;	
	wire[7:0]		idx_v  	= counter_v >= G_blank_v ? counter_v - G_blank_v : 0;
	wire[15:0]	idx_g		= {idx_v[7:0], idx_h[7:0]};
	
	
	(* ram_init_file = "assets/mario.img.mif" *)
	bit[7:0]		bitmap[61439:0];
	
	(* ram_init_file = "assets/mario.pal.mif" *)
	bit[31:0]		palette[10:0];
	
	bit[7:0]		bitmap_bits 	= 0;
	bit[32:0]		palette_bits 	= 0;
			
	assign 			out_red   	= palette_bits[23:16];
	assign 			out_green 	= palette_bits[15:8];
	assign 			out_blue  	= palette_bits[7:0];	
	
	always @(posedge clock, negedge reset)
	begin
		if (~reset) begin
			counter_v <= 0;
			counter_h <= 0;
			lat_hsync <= 0;
			lat_vsync <= 0;
		end
		else begin
			palette_bits <= palette[bitmap_bits];
			bitmap_bits <= bitmap[idx_g];
		
			if (counter_h == G_ticks_h - 1) 
			begin
				counter_h <= 0;
				if (counter_v == G_ticks_v - 1) 
				begin
					counter_v <= 0;
				end else 
				begin
					counter_v <= counter_v + 1;
				end
			end else 
			begin
				counter_h <= counter_h + 1;
			end
			lat_hsync <= (counter_h < G_front_h) || (counter_h >= (G_blank_h - G_back_h));
			lat_vsync <= (counter_v < G_front_v) || (counter_v >= (G_blank_v - G_back_v));
		end
	end

endmodule