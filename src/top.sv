module top(clock, reset, io_tx, io_rx, led);

	input 	wire clock;
	input 	wire reset;
	output 	wire io_tx;
	output 	wire io_rx;
	output	wire led;

	wire reset_db;

	debnc  #(.TimeOut(64), .Inverted(1)) _debnc (.clock(clock), .sigin(reset), .sigout(reset_db));	
	clkdiv #(.From(50000000), .DownTo(1000000)) _dut0  (.clock(clock), .reset(reset_db), .ckena(reset), .ckout(io_tx));
	clkdiv #(.From(50000000), .DownTo(2000000)) _dut1  (.clock(clock), .reset(reset_db), .ckena(reset), .ckout(io_rx));
	clkdiv #(.From(50000000), .DownTo(0.50000)) _dut2  (.clock(clock), .reset(reset_db), .ckena(reset), .ckout(led));

endmodule