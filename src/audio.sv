module audio (
  input   inp_clock	,
  input   inp_reset	,
  output  out_mclk	, // Master clock
  output  out_wclk	, // Word clock
  output  out_sclk	, // Serial Data Clock
  output  out_data	);

	
  assign  out_mclk = 0;	
	assign  out_sclk = 0;
	assign  out_wclk = 0;
	assign  out_data = 0;
  	
  always @(posedge inp_clock, negedge inp_reset)
  begin
    if (~inp_reset)
    begin      
    end else 
    begin
    end
  end  

endmodule