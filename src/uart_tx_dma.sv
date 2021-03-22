module uart_tx_dma 
  #(parameter 
    Clock = 50000000, 
    Baud  = 9600, 
    Stop  = 4) 
  ( input   wire        clock, 
    input   wire        reset, 
    input   wire        dtrdy,
    input   wire[7:0]   data, 
    output  bit[7:0]    addr,
    input   wire[7:0]   leng,
    output  bit[7:0]    stat,
    output  wire        txd, 
    output  wire        cts);

  wire _next;

  uart_tx #(.Clock(Clock), .Baud(Baud), .Stop(Stop))
    _uatx (.clock(clock), .reset(reset), .data(data), .txd(txd), .cts(_next), .reptx(1'b1));
  
  always @(posedge _next or negedge ~reset)
  begin
    if (~reset)
    begin
      addr <= 0;
      stat <= leng;
    end else begin      
      addr <= addr + 1;
      stat <= stat - 1;
    end
  end


endmodule