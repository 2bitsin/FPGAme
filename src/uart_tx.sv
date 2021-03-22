
module uart_tx #(parameter Clock = 50000000, Baud = 9600, Stop = 2) (clock, reset, data, txd, cts, reptx);

  localparam T = integer' (Clock/Baud);
  localparam Q = $clog2 (T);
  localparam S = $clog2 (10 + Stop);

  input   wire        clock;
  input   wire        reset;  
  input   wire[7:0]   data;
	input 	wire				reptx;

  output  bit         txd;
  output  wire        cts;

          wire        clktx;

          bit[S-1:0]  state;
          bit[7:0]    dataw;

  assign txd =  (~reset || state >= 10 || state == 0) ? 1 :
                (state == 1) ? 0 :
                dataw[state-2];                
  assign cts =  (state == (10 + Stop));

  clkdiv 
    #(.From   (Clock), 
      .DownTo (Baud)) 
    baudg 
    ( .clock  (clock),        
      .reset  (reset), 
      .ckena  (reset), 
      .ckout  (clktx));

  always @(negedge clktx or negedge reset)
  begin
    if (~reset)
    begin
      state <= 0;
      dataw <= data;
    end else 
    begin      
      if (state != (Stop + 10))
        state <= state + 1;
			else if (reptx)
				state <= 0;			
			if (state == 1)
        dataw <= data;
    end
  end


endmodule  