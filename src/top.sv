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
	wire clock_system;
	wire clock_locked;
	
	assign led = ~reset & clock_locked;
	
	wire[15:0] 	cpu_addr;
	wire				cpu_rdwr;
	wire[7:0]		cpu_rd_data;
	wire[7:0]		cpu_wr_data;
	wire 				cpu_sync;
	wire				cpu_phy2;
	wire				cpu_ready = 1;
	wire				cpu_nmi = 1;
	wire				cpu_irq = 1;
	
	wire[15:0]	ppu_addr;
	wire				ppu_cs;	
	wire				ppu_rdwr;
	wire[7:0]		ppu_wr_data;
	wire[7:0]		ppu_rd_data;
	
	wire[14:0]	ram_addr;
	wire				ram_cs;
	wire				ram_rdwr;
	wire[7:0]		ram_wr_data;
	wire[7:0]		ram_rd_data;
	
	wire[14:0]	rom_addr;
	wire				rom_cs;
	wire				rom_rdwr;
	wire[7:0]		rom_wr_data;
	wire[7:0]		rom_rd_data;
	
	assign			ppu_addr 		= {7'h00, cpu_addr[8:0]};
	assign 			ppu_cs			= cpu_addr[15:9] == 7'h3F;	
	assign			ppu_rdwr		= cpu_rdwr;
	assign			ppu_wr_data	= cpu_wr_data;
	assign			ppu_rd_data = cpu_rd_data;
	
	assign			ram_addr		= cpu_addr[14:0];
	assign			ram_cs			= ~cpu_addr[15] && ~ppu_cs;
	assign			ram_rdwr		= cpu_rdwr;
	assign			ram_wr_data	= cpu_wr_data;
	assign			ram_rd_data = cpu_rd_data;
	
	assign			rom_addr		= cpu_addr[14:0];
	assign			rom_cs			= cpu_addr[15];
	assign			rom_rdwr		= cpu_rdwr;
	assign			rom_wr_data	= cpu_wr_data;
	assign			rom_rd_data = cpu_rd_data;
		
	
	mod_altera_pll 					e0 (clock, ~reset, clock_video, clock_audio, clock_locked);											
	video 									e1 (clock_video, reset, vid_red, vid_green, vid_blue, vid_hsync, vid_vsync, vid_blank, vid_clock, clock_system, ppu_addr, ppu_rdwr, ppu_cs, ppu_wr_data, ppu_rd_data);		
 	dual_port_ram #(32768)  e2 (clock_system, ram_cs, ram_addr, ram_rdwr, ram_rd_data, ram_wr_data, , , , , );
	Q2A03										e3 (clock_system, reset, cpu_irq, cpu_nmi, cpu_addr, cpu_wr_data, cpu_rd_data, cpu_rdwr, cpu_ready, cpu_sync, cpu_phy2);
	testrom									e4 (clock_system, rom_cs, rom_addr, rom_rd_data);
endmodule