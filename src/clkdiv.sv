module clkdiv #(parameter From = 50000000, DownTo = 9600) (clock, reset, ckout, ckena);

  localparam T = integer' (From / DownTo);
  localparam Q = $clog2 (T);
  localparam H = integer' (T/2);

  localparam _Fail_if_Q_is_zero = 1 / Q;

  typedef bit[Q-1:0] period_type;

	input   wire clock ;
  input   wire reset ;
  input   wire ckena ;
  output  wire ckout ;	
	
  //initial begin    
  //  $display("%f %f %f\n", T, Q, H);
  //end


  generate
    if (T == 1) 
    begin
      assign ckout = ckena ? clock : 1'b0;      
    end 
    else if (T == 2)
    begin
      bit ckout_q = 0;
      assign ckout = ckena ? ckout_q : 1'b0;      
			        
      always @(posedge clock or negedge reset) 
			begin
				if (~reset)
					ckout_q <= 0;
				else if (ckena)
					ckout_q <= ~ckout_q;
			end
    end 
    else if (T != 2**Q)
    begin
      period_type ckout_t = period_type' (T-1);
      bit ckout_q = 0;
			
      assign ckout = ckena ? ~ckout_q : 1'b0;         

      always @(posedge clock or negedge reset) 
			begin
				if (~reset)
					{ckout_q, ckout_t} <= {1'b0, period_type' (T-1)};
				else if (ckena) 
				begin
					if (ckout_t == H-1)
						ckout_q <= 1;
					if (ckout_t == T-1) begin
						ckout_q <= 0;
						ckout_t <= 0;
					end else 
						ckout_t <= period_type' (ckout_t + 1);
				end  
			end
    end
    else 
    begin
      period_type ckout_t;
      assign ckout = ckena ? ~ckout_t[Q-1] : 1'b0;
      always @(posedge clock, negedge reset) 
			begin
				if (~reset) 
				begin
					ckout_t <= period_type' (-1);
				end else
				begin
					if (ckena)
					begin
						if (ckout_t != T-1)
							ckout_t <= ckout_t + 1;
						else 
							ckout_t <= 0;
					end
				end
			end
    end

  endgenerate

endmodule