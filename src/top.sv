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
	output	wire			aud_data,
	
	output 	wire			mb0_addr[18:0],
	inout   wire    	mb0_data[7:0],
	output  wire			mb0_oe,
	output  wire			mb0_we,
	output  wire			mb0_ce,
	
	output	wire			mb1_addr[18:0],
	inout   wire      mb1_data[7:0],
	output  wire			mb1_oe,
	output  wire			mb1_we,
	output  wire			mb1_ce,
	
	input		wire			jp0_up,
	input		wire			jp0_down,
	input		wire			jp0_left,
	input		wire			jp0_right,
	input		wire			jp0_a_b,
	input		wire			jp0_c_s,
	output  wire			jp0_sel,
	
	input		wire			jp1_up,
	input		wire			jp1_down,
	input		wire			jp1_left,
	input		wire			jp1_right,
	input		wire			jp1_a_b,
	input		wire			jp1_c_s,
	output  wire			jp1_sel);

		
	wire clock_video;
	wire clock_audio;
	wire clock_locked;
	
	assign led = ~reset & clock_locked;
		
	
	mod_altera_pll 	e0 (clock, ~reset, clock_video, clock_audio, clock_locked);	
	video 					e1 (clock_video, reset, vid_red, vid_green, vid_blue, vid_hsync, vid_vsync, vid_blank, vid_clock);		
	audio 					e2 (clock_audio, reset, aud_mclk, aud_wclk, aud_sclk, aud_data);
	Q2A03						e3 (clock, reset, 1, 1, /*addr*/, /*wr_data*/, 0, /*rdwr*/, 1, /*sync*/, /*phy2*/);
 	
	task automatic foo (	
		input 	wire a, 
		output 	wire b);
		
		bit ck = 0;		
		
		begin
			ck <= ~ck;
			b <= (ck + a);
		end
	endtask

	always @(posedge clock)
	begin
		foo(1'b1, io_tx);
		foo(1'b0, io_rx);
	end
endmodule