`define CLOCK_FREQ 	50000000
`define BAUD_RATE 	115200

`define ID_PIN(Pin, Id) uart_tx #(.Clock(`CLOCK_FREQ), .Baud(`BAUD_RATE), .Stop(5)) _uart_``Pin`` (.clock(clock), .reset(reset_db), .data(Id), .txd(Pin), .cts(), .reptx(1'b1))


module top(
	input 	wire 			clock, 
	input 	wire 			reset,
	output 	wire 			io_tx, 
	output 	wire 			io_rx,
	output 	wire 			led,
	
	output 	wire[7:0] vid_red,
	output 	wire[7:0] vid_green,
	output 	wire[7:0] vid_blue,
	output 	wire 			vid_hsync,
	output 	wire 			vid_vsync,
	output 	wire 			vid_blank,
	output 	wire 			vid_clock,
	
	output	wire			aud_mclk,
	output 	wire			aud_wclk,
	output	wire			aud_sclk,
	output	wire			aud_data);

		
	wire clock_video;
	wire clock_audio;
	wire clock_locked;
	
	assign io_tx = 0; 
	assign io_rx = 0;
	assign led = ~reset;
		
	//`ID_PIN(io_rx, 8'h01);
	//`ID_PIN(io_tx, 8'h02);
	//`ID_PIN(vid_clock, 8'h03);
	//`ID_PIN(vid_blank, 8'h04);
	//`ID_PIN(vid_hsync, 8'h05);
	//`ID_PIN(vid_vsync, 8'h06);
	
	mod_altera_pll _clockgen (
		.refclk     ( clock        ),
	  .rst        ( ~reset       ),
		.outclk_0   ( clock_video  ),
		.outclk_1   ( clock_audio  ),
		.locked     ( clock_locked )
	);
	
	video _video_driver (	
		.out_red		( vid_red	     ),		
		.out_green	( vid_green    ),
		.out_blue		( vid_blue     ),
		.out_hsync	( vid_hsync    ),
		.out_vsync	( vid_vsync    ),
		.out_blank	( vid_blank    ),
		.out_clock	( vid_clock    ),		
		.inp_clock	( clock_video  ),
		.inp_reset  ( reset        )
	);
	
	audio _audio_driver (
	  .inp_clock	( clock_audio  ),
		.inp_reset  ( reset				 ),
		.out_mclk		( aud_mclk     ),
		.out_wclk   ( aud_wclk     ),
		.out_sclk   ( aud_sclk     ),
		.out_data   ( aud_data     )
	);

endmodule