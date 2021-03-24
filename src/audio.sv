module audio (
  input   inp_clock	,
  input   inp_reset	,
  output  out_mclk	, // Master clock
  output  out_wclk	, // Word clock
  output  out_sclk	, // Serial Data Clock
  output  out_data	);

	localparam unsigned last_sample = 87352;
	
	(* ram_init_file = "assets/audio.mif" *)
	bit[7:0] 	 	samples[0:last_sample];
	
	bit[8:0]  	divtick = 0;
	bit[16:0]		counter = 0;
	bit[8:0]		current = 0;
	bit[7:0]		tsample = 0;
	bit					lastwck	= 0;
	bit					lastsck	= 0;
	bit[1:0]		d3count = 0;
	
  assign  out_mclk = inp_clock;	
	assign  out_sclk = divtick[2];
	assign  out_wclk = divtick[8];
	assign  out_data = current[8];
  	
  always @(posedge inp_clock, negedge inp_reset)
  begin
    if (~inp_reset)
    begin      
			divtick <= 0;
			counter <= 0;
			current <= 0;
			lastwck <= 0;
			lastsck	<= 0;
			d3count <= 0;
			tsample <= 0;
    end else 
    begin      
			divtick <= divtick + 9'b1;
			lastwck <= out_wclk;
			lastsck <= out_sclk;
			tsample <= samples[counter];
			
			
			if (lastwck != out_wclk)
			begin
				current <= tsample;
			end
			else if (~lastsck && out_sclk)
			begin
				current <= (current << 1);
			end

			if (~lastwck && out_wclk)
			begin				
				if (d3count < 2)
				begin
					d3count <= d3count + 1'b1;
				end	else 
				begin
					d3count <= 0;					
					counter <= counter + 1'b1;				
					if (counter == last_sample)
						counter <= 0;
				end
			end
    end
  end
 
  

endmodule