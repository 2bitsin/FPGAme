
module uart_tx #(parameter Clock = 50000000, Baud = 9600) (clock, reset, txen, data, txd, cts);

  localparam T = integer' (Clock/Baud);
  localparam Q = $clog2 (T);

  input   wire        clock;
  input   wire        reset;
  input   wire        txen;
  input   wire[7:0]   data;

  output  wire        txd;
  output  wire        cts;

          bit[3:0]    state;
          bit[7:0]    dataw;
          bit[Q-1:0]  ckdiv;


  assign txd =  (~txen || state >= 9) ? 1 :
                (state == 0)          ? 0 :
                                        dataw[state-1];
  assign cts =  (state == 9);
  
  always @(posedge clock or negedge reset)
  if (~reset) begin
    {state, dataw, ckdiv} <= 0;
  end else if (txen) begin
    if (ckdiv != T)
      ckdiv <= ckdiv + 1;
    else begin
      if (state == 0)
        dataw <= data;
      ckdiv <= 0;      
      state <= state + 1;
    end        
  end else begin
    state <= 0;
  end

endmodule  