module audio (
  input   inp_clock	,
  input   inp_reset	,
  output  out_mclk	, // Master clock
  output  out_wclk	, // Word clock
  output  out_sclk	, // Serial Data Clock
  output  out_data	);

  bit[32:0] lfsr;
	bit[8:0]  tick;
	
	assign  out_wclk = tick[8];
	assign  out_sclk = tick[3];
  assign  out_mclk = inp_clock;	
	assign  out_data = lfsr[32];
  	
  always @(posedge inp_clock, negedge inp_reset)
  begin
    if (~inp_reset)
    begin
      lfsr <= 0;
			tick <= 0;
    end else 
    begin      
			tick <= tick + 10'b1;
			if (~out_wclk)
				lfsr <= {lfsr[31:0], (lfsr[32] ^~ lfsr[22] ^~ lfsr[2] ^~ lfsr[1])};
    end
  end
 
  

endmodule