module debnc #(parameter TimeOut = 1000, Inverted = 0) (clock, sigin, sigout);

  localparam Q = $clog2 (TimeOut);

  input   wire  clock;
  input   wire  sigin;

  output  wire  sigout;

  typedef bit[Q-1:0] period_type;

  period_type count_down = 0;


  generate
    if (!Inverted) begin
      assign sigout = (count_down != 0);  
      always @(posedge clock or posedge sigin)
      begin
        if (sigin) 
          count_down <= period_type' (TimeOut - 1);
        else if (count_down != 0)
          count_down <= count_down - 1;        
      end
    end else begin
      assign sigout = ~(count_down != 0);  
      always @(posedge clock or negedge sigin)
      begin
        if (~sigin) 
          count_down <= period_type' (TimeOut - 1);
        else if (count_down != 0)
          count_down <= count_down - 1;        
      end      
    end
  endgenerate
endmodule