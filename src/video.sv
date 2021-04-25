
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

	
	localparam G_active_h 		= 256;
	localparam G_active_v 		= 240;
	
	localparam G_front_h 			= 9;
	localparam G_sync_h 			= 51;
	localparam G_back_h 			= 25;

	localparam G_front_v 			= 5;
	localparam G_sync_v 			= 1;
	localparam G_back_v 			= 16;

	localparam G_blank_h  		= G_front_h + G_sync_h + G_back_h;
	localparam G_blank_v 			= G_front_v + G_sync_v + G_back_v;
	
	localparam G_ticks_h 			= G_active_h + G_blank_h;
	localparam G_ticks_v			= G_active_v + G_blank_v;		
	
	bit[15:0] 	counter_v			= 0;
	bit[15:0] 	counter_h			= 0;	
	bit 				lat_hsync 		= 0;
	bit 				lat_vsync 		= 0; 
		
	assign 			out_hsync 		= lat_hsync;
	assign 			out_vsync 		= lat_vsync;
	assign 			out_clock 		= clock;
	assign 			out_blank 		= counter_v >= G_blank_v && counter_h >= G_blank_h;
	
	wire[15:0]  active_h 			= counter_h - G_blank_h;
	wire[15:0]  prefetch_h		= counter_h + 8 - G_blank_h;
	wire[15:0]  active_v			= counter_v - G_blank_v;	
	wire[7:0]		prefetch_col	= prefetch_h[10:3];
	wire[7:0]		active_col		= active_h[10:3];
	wire[7:0]		active_row		= active_v[11:4];	
	wire[2:0]		tile_h				= active_h[2:0];
	wire[3:0]		tile_v				= active_v[3:0];
	
	bit[11:0]		font_addr 		= 0;
	wire[7:0]		font_data;
	bit[8:0]		scrn_addr 		= 0;
	wire[7:0]		scrn_data;
	
	font8x16 		font_bits (clock, font_addr, font_data);
	screen0  		scrn_bits (clock, scrn_addr, scrn_data);
		
	bit[7:0]		tile_bits;		
	wire[7:0] 	out_color = {8{tile_bits[7]}};
	
	assign out_red   = out_color;
	assign out_green = out_color;
	assign out_blue  = out_color;
	
	always @(posedge clock, negedge reset)
	begin
		if (~reset) begin
			counter_v <= 0;
			counter_h <= 0;
			lat_hsync <= 0;
			lat_vsync <= 0;
			font_addr <= 0;
			scrn_addr <= 0;
			tile_bits <= 0;
		end
		else begin
			
			tile_bits <= {tile_bits[6:0], 1'b0};
			
			if ($signed(prefetch_h) >= $signed(0) 
			 && $signed(active_v  ) >= $signed(0))
			begin				
				case (prefetch_h[2:0])				
					0: scrn_addr <= prefetch_col + {active_row, 5'b0};					
					3: font_addr <=  {4'h0, scrn_data, 4'h0} + tile_v;					
					7: tile_bits <= font_data;					
					default:;	
				endcase
			end
			
			
			
			if (counter_h == G_ticks_h - 1) 
			begin
				counter_h <= 0;
				if (counter_v == G_ticks_v - 1) 
					counter_v <= 0;
				else 
					counter_v <= counter_v + 1;
			end else 
				counter_h <= counter_h + 1;
				
			lat_hsync <= (counter_h < G_front_h) || (counter_h >= (G_blank_h - G_back_h));
			lat_vsync <= (counter_v < G_front_v) || (counter_v >= (G_blank_v - G_back_v));
		end
	end

endmodule